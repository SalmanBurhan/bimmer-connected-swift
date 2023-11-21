//
//  MyBMWRegion.swift
//  myBMW
//
//  Created by Salman Burhan on 11/14/23.
//

import Foundation

public enum MyBMWRegion: UIFriendlyRawRepresentable {
    
    case NORTH_AMERICA
    case REST_OF_WORLD

    public var value: String  {
        switch self {
        case .NORTH_AMERICA: "na"
        case .REST_OF_WORLD: "row"
        }
    }
    
    public var friendlyValue: String {
        switch self {
        case .NORTH_AMERICA: "North America"
        case .REST_OF_WORLD: "Rest of the World"
        }
    }
    
    public init?(rawValue: RawValue) {
        guard let value = Self.allCases.first(where: { $0.value == rawValue })
        else { return nil }
        self = value
    }
}
