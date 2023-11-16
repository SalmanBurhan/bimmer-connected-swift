//
//  MyBMWRequest.swift
//  myBMW
//
//  Created by Salman Burhan on 11/15/23.
//

import Foundation

public enum HTTPMethod: String, Sendable {
    case get
    case post
}

public struct MyBMWRequest<Response>: Sendable {
    public let method: HTTPMethod
    public let path: String
    public var headers: [String: String]?
    public var query: [String: String]?
    
    init(
        endpoint: MyBMWEndpoint,
        method: HTTPMethod,
        headers: [String : String]? = nil,
        query: [String : String]? = nil
    ) {
        self.method = method
        self.path = endpoint.path
        self.headers = headers
        self.query = query
    }
}
