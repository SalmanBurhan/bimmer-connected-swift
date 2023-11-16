//
//  MyBMWLoginClient.swift
//  myBMW
//
//  Created by Salman Burhan on 11/14/23.
//

import Foundation

public actor MyBMWLoginClient {
    
    let constants: MyBMWConstants
    let session: URLSession
    let baseURL: URL
    let encoder: JSONEncoder
    let decoder: JSONDecoder
    
    init(_ region: MyBMWRegion) {
        self.constants = MyBMWConstants(carBrand: .BMW, region: region)
        self.baseURL = self.constants.serverURL
        let delegate = MyBMWHTTPLoginClientDelegate()
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 30 /// Seconds
        configuration.httpAdditionalHeaders = ["User-Agent": self.constants.userAgent,
                                               "X-User-Agent": self.constants.xUserAgent]
        self.session = URLSession(configuration: configuration, delegate: delegate, delegateQueue: nil)
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601
        self.encoder = JSONEncoder()
        self.encoder.dateEncodingStrategy = .iso8601
    }
    
    public func makeURLRequest<T>(for request: MyBMWRequest<T>) async throws -> URLRequest {
        let url = request.isPathRequest ? self.constants.serverURL.appending(path: request.path!) : request.url!
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = request.headers
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        if urlRequest.value(forHTTPHeaderField: "Accept") == nil {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        }
        
        return urlRequest
    }
    
    public func send<T: Decodable>(_ request: MyBMWRequest<T>) async throws -> MyBMWResponse<T> {
        let response = try await response(for: request)
        let value: T = try self.decoder.decode(T.self, from: response.data)
        return MyBMWResponse(value: value, response: response.urlResponse, data: response.data)
    }
    
    public func response<T>(for request: MyBMWRequest<T>) async throws -> (data: Data, urlResponse: URLResponse) {
        let urlRequest = try await makeURLRequest(for: request)
        let (data, response) = try await self.session.data(for: urlRequest)
        try self.validate(response)
        return (data, response)
    }
    
    private func validate(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse
        else { throw URLError(.badServerResponse) }
        guard httpResponse.statusCode == 200
        else { throw MyBMWError.unacceptableResponseCode(self, code: httpResponse.statusCode, url: response.url) }
    }
}

class MyBMWHTTPLoginClientDelegate: NSObject, URLSessionDelegate, URLSessionDataDelegate {
    
    private var retriesLeft = 3
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 429 {
                handle429Response(completionHandler: completionHandler)
                return
            } else if httpResponse.statusCode == 200 {
                retriesLeft = 3
            }
        }
        completionHandler(.allow)
    }
    
    private func handle429Response(completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        guard retriesLeft > 0 else {
            completionHandler(.allow)
            return
        }
        
        retriesLeft -= 1
        print("Encountered HTTP Code 429 (Too Many Requests) - Number of Retries left: \(retriesLeft)")
        
        let waitTime = Int.random(in: 2...10)
        print("Sleeping for \(waitTime) seconds due to HTTP Code 429 (Too Many Requests)")
        
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(waitTime)) {
            completionHandler(.cancel)
        }
    }
}
