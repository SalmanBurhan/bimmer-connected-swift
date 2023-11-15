//
//  MyBMWRemoteService.swift
//  myBMW
//
//  Created by Salman Burhan on 11/15/23.
//

import Foundation

/// Enumeration of possible services to be executed.
enum MyBMWRemoteService: String {
    
    case lightFlash = "light-flash"
    case vehicleFinder = "vehicle-finder"
    case lockDoor = "door-lock"
    case unlockDoor = "door-unlock"
    case honkHorn = "horn-blow"
    case preconditioning = "climate-now"
    case sendPointOfInterest = "SEND_POI"
    
    var formattedName: String {
        switch self {
        case .lightFlash: "Flash Lights"
        case .vehicleFinder: "Vehicle Finder"
        case .lockDoor: "Lock Door"
        case .unlockDoor: "Unlock Door"
        case .honkHorn: "Honk Horn"
        case .preconditioning: "Precondition"
        case .sendPointOfInterest: "Send Point of Interest"
        }
    }
}
