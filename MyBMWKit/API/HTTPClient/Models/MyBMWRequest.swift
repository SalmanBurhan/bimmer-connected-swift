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

public struct MyBMWRequest<T>: @unchecked Sendable {
    public let method: HTTPMethod
    public var path: String?
    public var url: URL?
    public var headers: [String: String]?
    public var query: [String: String]?
    public let body: Data?
    
    public var isPathRequest: Bool { self.url == nil }
    
    init(endpoint: MyBMWEndpoint,
         method: HTTPMethod,
         headers: [String: String]? = nil,
         query: [String: String]? = nil,
         body: Data? = nil
    ) {
        self.method = method
        self.path = endpoint.path
        self.headers = headers
        self.query = query
        self.body = body
    }
    
    init(url: URL,
         method: HTTPMethod,
         headers: [String: String]? = nil,
         query: [String: String]? = nil,
         body: Data? = nil
    ) {
        self.method = method
        self.url = url
        self.headers = headers
        self.query = query
        self.body = body
    }
}
