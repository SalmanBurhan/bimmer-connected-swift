//
//  MyBMWRemoteService.swift
//  myBMW
//
//  Created by Salman Burhan on 11/15/23.
//

import Foundation

/// Enumeration of possible services to be executed.
public enum MyBMWRemoteService: UIFriendlyRawRepresentable {
    
    case lightFlash
    case vehicleFinder
    case lockDoor
    case unlockDoor
    case honkHorn
    case preconditioning
    case sendPointOfInterest
    case charging(MyBMWRemoteChargingService)
    
    public var value: String {
        switch self {
        case .lightFlash: "light-flash"
        case .vehicleFinder: "vehicle-finder"
        case .lockDoor: "door-lock"
        case .unlockDoor: "door-unlock"
        case .honkHorn: "horn-blow"
        case .preconditioning: "climate-now"
        case .sendPointOfInterest: "SEND_POI"
        case .charging(let chargingService): chargingService.value
        }
    }
    
    public var friendlyValue: String {
        switch self {
        case .lightFlash: "Flash Lights"
        case .vehicleFinder: "Vehicle Finder"
        case .lockDoor: "Lock Door"
        case .unlockDoor: "Unlock Door"
        case .honkHorn: "Honk Horn"
        case .preconditioning: "Precondition"
        case .sendPointOfInterest: "Send Point of Interest"
        case .charging(let chargingService): chargingService.value
        }
    }
    
    public static var allCases: [MyBMWRemoteService] = {
        [.lightFlash, .vehicleFinder, .lockDoor, .unlockDoor,
         .honkHorn, .preconditioning, .sendPointOfInterest]
        + MyBMWRemoteChargingService.allCases.map({ .charging($0) })
    }()

    public init?(rawValue: String) {
        guard let value = Self.allCases.first(where: { $0.value == rawValue })
        else { return nil }
        self = value
    }
}
