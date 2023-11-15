//
//  MyBMWURLBuilder.swift
//  myBMW
//
//  Created by Salman Burhan on 11/14/23.
//

import Foundation

enum MyBMWURLBuilder {
    case OAUTH_CONFIG_URL
    
    case VEHICLES_URL
    case VEHICLE_STATE_URL
    
    case REMOTE_SERVICE_BASE_URL
    case REMOTE_SERVICE_URL(vin: String, serviceType: String)
    case REMOTE_SERVICE_STATUS_URL(eventId: String)
    case REMOTE_SERVICE_POSITION_URL(eventId: String)
    
    case VEHICLE_CHARGING_DETAILS_URL
    case VEHICLE_CHARGING_BASE_URL(vin: String)
    case VEHICLE_CHARGING_SETTINGS_SET_URL(vin: String)
    case VEHICLE_CHARGING_PROFILE_SET_URL(vin: String)
    case VEHICLE_CHARGING_START_STOP_URL(vin: String, serviceType: String)
    
    case VEHICLE_IMAGE_URL(vin: String, carView: String)
    case VEHICLE_POI_URL
    
    case VEHICLE_CHARGING_STATISTICS_URL
    case VEHICLE_CHARGING_SESSIONS_URL
    
    case SERVICE_CHARGING_STATISTICS_URL
    case SERVICE_CHARGING_SESSIONS_URL
    case SERVICE_CHARGING_PROFILE
    
    func build() -> String {
        switch self {
        case .OAUTH_CONFIG_URL:
            "/eadrax-ucs/v1/presentation/oauth/config"
            
        case .VEHICLES_URL:
            "/eadrax-vcs/v4/vehicles"
            
        case .VEHICLE_STATE_URL:
            "\(Self.VEHICLES_URL.build())/state"
            
        case .REMOTE_SERVICE_BASE_URL:
            "/eadrax-vrccs/v3/presentation/remote-commands"
            
        case .REMOTE_SERVICE_URL(let vin, let serviceType):
            "\(Self.REMOTE_SERVICE_BASE_URL.build())/\(vin)/\(serviceType)"
            
        case .REMOTE_SERVICE_STATUS_URL(let eventId):
            "\(Self.REMOTE_SERVICE_BASE_URL.build())/eventStatus?eventId=\(eventId)"
            
        case .REMOTE_SERVICE_POSITION_URL(let eventId):
            "\(Self.REMOTE_SERVICE_BASE_URL.build())/eventPosition?eventId=\(eventId)"
            
        case .VEHICLE_CHARGING_DETAILS_URL:
            "/eadrax-crccs/v2/vehicles"
            
        case .VEHICLE_CHARGING_BASE_URL(let vin):
            "/eadrax-crccs/v1/vehicles/\(vin)"
            
        case .VEHICLE_CHARGING_SETTINGS_SET_URL(let vin):
            "\(Self.VEHICLE_CHARGING_BASE_URL(vin: vin).build())/charging-settings"
            
        case .VEHICLE_CHARGING_PROFILE_SET_URL(let vin):
            "\(Self.VEHICLE_CHARGING_BASE_URL(vin: vin).build())/charging-profile"
            
        case .VEHICLE_CHARGING_START_STOP_URL(let vin, let serviceType):
            "\(Self.VEHICLE_CHARGING_BASE_URL(vin: vin).build())/\(serviceType)"
            
        case .VEHICLE_IMAGE_URL(let vin, let carView):
            "/eadrax-ics/v3/presentation/vehicles/\(vin)/images?carView=\(carView)"
            
        case .VEHICLE_POI_URL:
            "/eadrax-dcs/v1/send-to-car/send-to-car"
            
        case .VEHICLE_CHARGING_STATISTICS_URL:
            "/eadrax-chs/v1/charging-statistics"
            
        case .VEHICLE_CHARGING_SESSIONS_URL:
            "/eadrax-chs/v1/charging-sessions"
            
        case .SERVICE_CHARGING_STATISTICS_URL:
            "CHARGING_STATISTICS"
            
        case .SERVICE_CHARGING_SESSIONS_URL:
            "CHARGING_SESSIONS"
            
        case .SERVICE_CHARGING_PROFILE:
            "CHARGING_PROFILE"
        }
    }
}
