//
//  MyBMWChargingService.swift
//  myBMW
//
//  Created by Salman Burhan on 11/15/23.
//

import Foundation

enum MyBMWChargingService: String {
        
    case updateChargingSettings = "CHARGING_SETTINGS"
    case updateChargingProfile = "CHARGING_PROFILE"

    var formattedName: String {
        switch self {
        case .updateChargingSettings: "Update Charging Settings"
        case .updateChargingProfile: "Update Charging Profile"
        }
    }

    enum ChargingOperation: String {
        case startCharging = "start-charging"
        case stopCharging = "stop-charging"
        
        var formattedName: String {
            switch self {
            case .startCharging: "Start Charging"
            case .stopCharging: "Stop Charging"
            }
        }
    }

}
