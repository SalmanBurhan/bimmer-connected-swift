//
//  MyBMWLogger.swift
//  myBMW
//
//  Created by Salman Burhan on 11/20/23.
//

import Foundation

enum MyBMWLogLevel: Int {
    case debug = 0
    case info = 1
    case warning = 2
    case error = 3
}

class MyBMWLogger {
    let name: String
    var logLevel: MyBMWLogLevel = .debug

    init(_ caller: AnyClass) {
        let callingClass = String(describing: caller)
        self.name = callingClass
    }

    init(name: String) {
        self.name = name
    }

    func log(_ message: String, level: MyBMWLogLevel) {
        guard level.rawValue >= logLevel.rawValue else {
            return
        }

        let formattedMessage = "\(Date()): [\(name)] [\(level)] - \(message)"
        print(formattedMessage)
    }

    func debug(_ message: String) {
        log(message, level: .debug)
    }

    func info(_ message: String) {
        log(message, level: .info)
    }

    func warning(_ message: String) {
        log(message, level: .warning)
    }

    func error(_ message: String) {
        log(message, level: .error)
    }
}
