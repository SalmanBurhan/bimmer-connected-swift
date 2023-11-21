//
//  MyBMWClient.swift
//  myBMW
//
//  Created by Salman Burhan on 11/19/23.
//

import Foundation

public class MyBMWClient: NSObject {
    let configuration: MyBMWClientConfiguration
    let constants: MyBMWConstants
    let decoder: JSONDecoder
    
    lazy var session = self.configureSession()
    
    lazy var logger: MyBMWLogger = {
        return MyBMWLogger(MyBMWAuthentication.self)
    }()

    init(with configuration: MyBMWClientConfiguration, brand: MyBMWCarBrand = .BMW) {
        self.configuration = configuration
        self.constants = MyBMWConstants(carBrand: brand, region: configuration.authentication.region)
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .custom(self.customDateDecodingStrategy)
    }
    
    private func configureSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = self.defaultHeaders()
        configuration.timeoutIntervalForResource = 30 /// Seconds
        return URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
    }
    
    private let customDateDecodingStrategy: (Decoder) throws -> Date = { decoder in
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")

        let container = try decoder.singleValueContainer()
        let dateString = try container.decode(String.self)

        let dateFormats = [
            "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
            "yyyy-MM-dd'T'HH:mm:ssZ",
            "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'",
            "yyyy-MM-dd'T'HH:mm:ss'Z'"
        ]
        for format in dateFormats {
            formatter.dateFormat = format
            if let date = formatter.date(from: dateString) {
                return date
            }
        }

        throw DecodingError.dataCorruptedError(
            in: container,
            debugDescription: "Cannot decode date string \(dateString)"
        )
    }
    
    private func defaultHeaders() -> [String: String] {
        var headers: [String: String] = [
            "accept-language": "en",
            "user-agent": self.constants.userAgent,
            "x-user-agent": self.constants.xUserAgent,
            "bmw-units-preferences": self.configuration.useMetricUnits ? "d=KM;v=L" : "d=MI;v=G",
            "bmw-session-id": self.configuration.authentication.sessionID,
            "24-hour-format": "true"
        ]
        MyBMWUtils.generateCorrelationHeaders().forEach({ headers[$0.key] = $0.value })
        return headers
    }
    
//    private func verifyToken() async {
//        let auth = self.configuration.authentication
//        guard let tokenData = auth.tokenData, tokenData.isExpired == false
//        else {
//            await auth.login()
//            return
//        }
//    }
    
    public func makeURLRequest<T>(for request: MyBMWRequest<T>) async throws -> URLRequest {
        let url = request.isPathRequest ? self.constants.serverURL.appending(path: request.path!) : request.url!
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = request.headers
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        /// accept application/json not included in default headers because there are cases
        /// i.e. vehicle image, where we will want to set a different accept header. to avoid clashing
        /// between session configuration applied header and user-defined header, we will simply add
        /// accept application/json when building the request, if a value was not defined in the request.
        /// ----
        /// authorization header is also set on a per request basis to reflect the most up to date token.
        if urlRequest.value(forHTTPHeaderField: "accept") == nil {
            urlRequest.setValue("application/json", forHTTPHeaderField: "accept")
        }
        let token = self.configuration.authentication.tokenData?.accessToken
        urlRequest.setValue("Bearer \(token ?? "")", forHTTPHeaderField: "authorization")
        
        return urlRequest
    }

    public func send<T: Decodable>(_ request: MyBMWRequest<T>) async throws -> MyBMWResponse<T> {
        let response = try await response(for: request)
        let value: T = try self.decoder.decode(T.self, from: response.data)
        return MyBMWResponse(value: value, response: response.urlResponse, data: response.data)
    }

    public func response<T>(for request: MyBMWRequest<T>) async throws -> (data: Data, urlResponse: URLResponse) {
        //await self.verifyToken()
        //let urlRequest = try await makeURLRequest(for: request)
        self.logger.debug("Beginning Request: \(request)")
        let (data, response) = try await self.data(for: request)
        
        print(response)
        print(String(data: data, encoding: .utf8))
        //try self.validate(response)
        return (data, response)
    }

    func data<T>(for request: MyBMWRequest<T>) async throws -> (Data, URLResponse) {
        do {
            let urlRequest = try await makeURLRequest(for: request)
            let (data, response) = try await self.session.data(for: urlRequest)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            let statusCode = httpResponse.statusCode
            switch statusCode {
            
                /// `OK` Response
            case 200:
                self.logger.debug("Request Successful: \(request)")
                return (data, response)
                
                /// `Forbidden` / `Too Many Requests` (Wrapped In A `Forbidden` Response)
            case 403:
                if let retryAfter = self.extractRetryAfterInterval(from: httpResponse) {
                    /// If `Retry-After` Header Is Present, Treat The Error As A `Too Many Requests` Error.
                    let error = MyBMWError2(.quotaExceeded(statusCode: statusCode, retryAfter: retryAfter))
                    self.logger.error(error.localizedDescription)
                    throw error
                }
                throw MyBMWError2(.unexpectedResponse(statusCode: statusCode))
                
                /// `Too Many Requests`
            case 429:
                /// We Will Not Attempt To Verify Presence Of `Retry-After`, As The Code Is Associated To The Error.
                let retryAfter = self.extractRetryAfterInterval(from: httpResponse)
                let error = MyBMWError2(.quotaExceeded(statusCode: statusCode, retryAfter: retryAfter))
                self.logger.error(error.localizedDescription)
                throw error

                /// `Unauthorized`
            case 401:
                self.logger.error("Received Unauthorized Response Header. Token May Be Expired.")
                /// Refresh Token or Login In Again
                await self.configuration.authentication.login()
                /// Retry Request
                let urlRequest = try await makeURLRequest(for: request)
                return try await self.session.data(for: urlRequest)
            
                /// All Other HTTP Status Codes Default to `unexpectedResponse(statusCode:)`.
            default:
                let error = MyBMWError2(.unexpectedResponse(statusCode: statusCode))
                self.logger.error(error.localizedDescription)
                throw error
            }
        } catch {
            self.logger.error(error.localizedDescription)
            throw error
        }
    }
    
//    private func validate(_ response: URLResponse, expectedStatusCode: Int = 200) throws {
//        guard let httpResponse = response as? HTTPURLResponse
//        else { throw URLError(.badServerResponse) }
//        guard httpResponse.statusCode == expectedStatusCode
//        else {
//            switch httpResponse.statusCode {
//            case 403, 429:
//                let retryAfter = httpResponse.value(forHTTPHeaderField: "Retry-After") ?? ""
//                throw MyBMWError2(.quotaExceeded(
//                    statusCode: httpResponse.statusCode,
//                    retryAfter: Int(retryAfter)
//                ), message: "Call volume quota exceeded")
//            default:
//                throw MyBMWError.unacceptableResponseCode(self, code: httpResponse.statusCode, url: response.url)
//            }
//        }
//    }
}

// MARK: - Error Handling Methods

extension MyBMWClient {
    
    func extractRetryAfterInterval(from response: HTTPURLResponse) -> String? {
        guard let retryAfter = response.value(forHTTPHeaderField: "Retry-After"),
              let seconds = Int(retryAfter) else {
            return nil
        }
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad

        guard let formattedString = formatter.string(from: TimeInterval(seconds)) else {
            return nil
        }

        return formattedString
    }
}
