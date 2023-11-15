//
//  MyBMWRequest.swift
//  myBMW
//
//  Created by Salman Burhan on 11/15/23.
//

import Foundation

public enum HTTPMethod: String {
    case get
    case post
}

public struct MyBMWRequest {
    var method: HTTPMethod
    var endpoint: MyBMWEndpoint
    var headers: [String: String]?
    var query: [String: String]?
    var body: Encodable?
}
