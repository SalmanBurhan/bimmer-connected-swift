//
//  MyBMWCarBrand.swift
//  myBMW
//
//  Created by Salman Burhan on 11/14/23.
//

import Foundation

/// Car brands supported by the MyBMW API.
public enum MyBMWCarBrand: UIFriendlyRawRepresentable {
    
    case BMW
    case MINI
    
    public var value: String {
        switch self {
        case .BMW: "BMW"
        case .MINI: "MINI"
        }
    }
    
    public var friendlyValue: String { self.value.uppercased() }

    public init?(rawValue: String) {
        guard let value = Self.allCases.first(where: { $0.value == rawValue })
        else { return nil }
        self = value
    }

}
