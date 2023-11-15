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
    
    init(_ region: MyBMWRegion) {
        self.constants = MyBMWConstants(carBrand: .BMW, region: region)
        self.session = URLSession(configuration: .default, delegate: MyBMWHTTPLoginClientDelegate(), delegateQueue: nil)
        self.session.configuration.timeoutIntervalForResource = 30 /// Seconds
        self.session.configuration.httpAdditionalHeaders = [
            "User-Agent": self.constants.userAgent,
            "X-User-Agent": self.constants.xUserAgent
        ]
    }
        
    func send(_ request: MyBMWRequest) async throws {
        let urlRequest = try await makeRequest(for: request)
        let (data, response) = try await self.session.data(for: urlRequest)
        print(data, response)
    }

    
    private func makeRequest(for request: MyBMWRequest) async throws -> URLRequest {
        let url = self.constants.serverURL.appending(path: request.endpoint.path)
        var urlRequest = URLRequest(url: url)
        urlRequest.allHTTPHeaderFields = request.headers
        urlRequest.httpMethod = request.method.rawValue
        
        if urlRequest.value(forHTTPHeaderField: "Accept") == nil {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        }
        
        return urlRequest
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
