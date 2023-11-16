//
//  MyBMWRemoteServicesEndpoint.swift
//  myBMW
//
//  Created by Salman Burhan on 11/15/23.
//

import Foundation

public enum MyBMWRemoteServiceEndpoint: MyBMWBaseableEndpoint {
    case base
    case service(vin: String, serviceType: String)
    case status(String)
    case position(String)
    
    public var path: String {
        return switch self {
        case .base: "/eadrax-vrccs/v3/presentation/remote-commands"
        case .service(let vin, let serviceType): "/\(vin)/\(serviceType)"
        case .status(let eventId): "/eventStatus?eventId=\(eventId)"
        case .position(let eventId): "/eventPosition?eventId=\(eventId)"
        }
    }
}
