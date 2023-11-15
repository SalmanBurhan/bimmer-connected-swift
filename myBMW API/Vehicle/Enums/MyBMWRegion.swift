//
//  MyBMWRegion.swift
//  myBMW
//
//  Created by Salman Burhan on 11/14/23.
//

import Foundation

enum MyBMWRegion: String {
    case NORTH_AMERICA = "na"
    case REST_OF_WORLD = "row"
    //case CHINA = "cn"

    func toString() -> String {
        switch self {
        case .NORTH_AMERICA: "North America"
        case .REST_OF_WORLD: "Rest of the World"
        //case .CHINA: "China"
        }
    }
}


