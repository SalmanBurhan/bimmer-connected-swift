//
//  MyBMWChargingEndpoint.swift
//  myBMW
//
//  Created by Salman Burhan on 11/15/23.
//

import Foundation

public enum MyBMWChargingEndpoint: MyBMWBaseableEndpoint {
    case base
    case settings(vin: String)
    case profile(vin: String)
    case charge(vin: String, action: MyBMWRemoteChargingService.ChargingAction)
    
    case details
    case statistics
    case sessions
    
    public var path: String {
        switch self {
        case .base: "/eadrax-crccs/v1/vehicles"
        case .settings(let vin): "/\(vin)/charging-settings"
        case .profile(let vin): "/\(vin)/charging-profile"
        case .charge(let vin, let action): "/\(vin)/\(action.value)"
        case .details: "/eadrax-crccs/v2/vehicles"
        case .statistics: "/eadrax-chs/v1/charging-statistics"
        case .sessions: "/eadrax-chs/v1/charging-sessions"
        }
    }
}
