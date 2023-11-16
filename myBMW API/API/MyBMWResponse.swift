//
//  MyBMWResponse.swift
//  myBMW
//
//  Created by Salman Burhan on 11/15/23.
//

import Foundation

public struct MyBMWResponse<T> {
    public let value: T
    public let response: URLResponse
    public let data: Data
    public var statusCode: Int? {
        (response as? HTTPURLResponse)?.statusCode
    }
}
