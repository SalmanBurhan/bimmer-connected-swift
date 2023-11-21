//
//  MyBMWEndpoint.swift
//  myBMW
//
//  Created by Salman Burhan on 11/14/23.
//

import Foundation

public enum MyBMWEndpoint {    
    case oAuthConfiguration
        
    case Vehicle(MyBMWVehicleEndpoint)
    case RemoteService(MyBMWRemoteServiceEndpoint)
    case Charging(MyBMWChargingEndpoint)

    private func nestedPath<T: MyBMWBaseableEndpoint>(_ endpoint: T) -> String {
        endpoint != .base ? T.base.path + endpoint.path : endpoint.path
    }
    
    var path: String {
        switch self {
        case .oAuthConfiguration: "/eadrax-ucs/v1/presentation/oauth/config"
        case .RemoteService(let endpoint): nestedPath(endpoint)
        case .Vehicle(let endpoint):
            switch endpoint {
            case .image, .pointOfInterest: endpoint.path
            default: nestedPath(endpoint)
            }
        case .Charging(let endpoint):
            switch endpoint {
            case .details, .statistics, .sessions: endpoint.path
            default: nestedPath(endpoint)
            }
        }
    }
}
