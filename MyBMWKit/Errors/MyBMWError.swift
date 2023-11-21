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
    case unacceptableResponseCode(_ thower: T, code: Int, url: URL?)
}

enum MyBMWAuthenticationError: Error {
    case authorizationCodeExtractionError
    case encodingError(description: String)
}

enum MyBMWError1 {
    case quotaExceeded(statusCode: Int, retryAfter: String?)
    case unexpectedResponse(statusCode: Int)
    
    var message: String {
        switch self {
            
        case .quotaExceeded(_, let retryAfter):
            guard let retryAfter = retryAfter
            else { return "Call Quota Exceeded." }
            return "Call Quota Exceeded. Please try again after time interval \(retryAfter)."
            
        case .unexpectedResponse(let statusCode):
            let codeDescription = HTTPURLResponse.localizedString(forStatusCode: 403).capitalized
            return "Reserver Returned Unexpected Status Code \(statusCode): \(codeDescription)."
        }
    }
}

struct MyBMWError2: Error {
    let type: MyBMWError1
    let file: String
    let function: String
    let line: Int

    var localizedDescription: String {
        return type.message
    }
    
    init(_ type: MyBMWError1, file: String = #file, function: String = #function, line: Int = #line) {
        self.type = type
        self.file = file
        self.function = function
        self.line = line
    }
}
