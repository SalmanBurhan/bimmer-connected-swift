//
//  MyBMWChargingService.swift
//  myBMW
//
//  Created by Salman Burhan on 11/15/23.
//

import Foundation

// MARK: - Charging Service

public enum MyBMWRemoteChargingService: UIFriendlyRawRepresentable {
    
    case updateChargingSettings
    case updateChargingProfile
    case action(ChargingAction)
    
    public var value: String {
        switch self {
        case .updateChargingSettings: "CHARGING_SETTINGS"
        case .updateChargingProfile: "CHARGING_PROFILE"
        case .action(let chargingOperation): chargingOperation.value
        }
    }
    
    public var friendlyValue: String {
        switch self {
        case .updateChargingSettings: "Update Charging Settings"
        case .updateChargingProfile: "Update Charging Profile"
        case .action(let chargingOperation): chargingOperation.friendlyValue
        }
    }
    
    
    public static var allCases: [MyBMWRemoteChargingService] = {
        [.updateChargingSettings, .updateChargingProfile]
        + ChargingAction.allCases.map({ .action($0) })
    }()
    
    
    public init?(rawValue: String) {
        guard let value = Self.allCases.first(where: { $0.value == rawValue })
        else { return nil }
        self = value
    }

}

// MARK: - Charging Operations

extension MyBMWRemoteChargingService {

    public enum ChargingAction: CaseIterable, UIFriendlyRawRepresentable {
        
        case startCharging
        case stopCharging
        
        public var value: String {
            switch self {
            case .startCharging: "start-charging"
            case .stopCharging: "stop-charging"
            }
        }
        
        public var friendlyValue: String {
            switch self {
            case .startCharging: "Start Charging"
            case .stopCharging: "Stop Charging"
            }
        }
        
        public static var allCases: [MyBMWRemoteChargingService.ChargingAction] = {
            return [.startCharging, .stopCharging]
        }()

        public init?(rawValue: String) {
            guard let value = Self.allCases.first(where: { $0.value == rawValue })
            else { return nil }
            self = value
        }
    }
    
}


/*
public enum MyBMWChargingService: String, CaseIterable, UIFriendlyRawRepresentable {
        
    case updateChargingSettings = "CHARGING_SETTINGS"
    case updateChargingProfile = "CHARGING_PROFILE"

    var friendlyValue: String {
        switch self {
        case .updateChargingSettings: "Update Charging Settings"
        case .updateChargingProfile: "Update Charging Profile"
        }
    }

    public enum ChargingOperation: String, UIFriendlyRawRepresentable {
        case startCharging = "start-charging"
        case stopCharging = "stop-charging"
        
        var friendlyValue: String {
            switch self {
            case .startCharging: "Start Charging"
            case .stopCharging: "Stop Charging"
            }
        }
    }
}
*/
