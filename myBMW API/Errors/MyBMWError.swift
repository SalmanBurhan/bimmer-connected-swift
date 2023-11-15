//
//  TypeMismatchError.swift
//  myBMW
//
//  Created by Salman Burhan on 11/14/23.
//

import Foundation

enum MyBMWError<T>: Error {
    case invalidInitialization(thrower: T, description: String)
    case decodingError(thrower: T, description: String)
    case maxRequestRetriesExceeded(thrower: T)
}
