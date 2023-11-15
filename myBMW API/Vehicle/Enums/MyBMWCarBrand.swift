//
//  MyBMWCarBrand.swift
//  myBMW
//
//  Created by Salman Burhan on 11/14/23.
//

import Foundation

/// Car brands supported by the MyBMW API.
enum MyBMWCarBrand: String {
    case BMW = "bmw"
    case MINI = "mini"
    
    func toString() -> String {
        return self.rawValue.uppercased()
    }
}
