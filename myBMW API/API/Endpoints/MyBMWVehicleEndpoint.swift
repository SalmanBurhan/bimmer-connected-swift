//
//  MyBMWVehicleEndpoint.swift
//  myBMW
//
//  Created by Salman Burhan on 11/15/23.
//

import Foundation

enum MyBMWVehicleEndpoint: MyBMWBaseableEndpoint {
    case base
    case state
    case image(vin: String, view: String)
    case pointOfInterest
    
    var path: String {
        switch self {
        case .base: "/eadrax-vcs/v4/vehicles"
        case .state: "/state"
        case .image(let vin, let view): "/eadrax-ics/v3/presentation/vehicles/\(vin)/images?carView=\(view)"
        case .pointOfInterest: "/eadrax-dcs/v1/send-to-car/send-to-car"
        }
    }
}
