//
//  GPSPosition.swift
//  myBMW
//
//  Created by Salman Burhan on 11/14/23.
//

import Foundation

/// GPS coordinates.
struct GPSPosition {
    let latitude: Float?
    let longitude: Float?
    
    init(latitude: Float? = nil, longitude: Float? = nil) throws {
        self.latitude = latitude
        self.longitude = longitude
        try self.postInit()
    }
    
    fileprivate func postInit() throws {
        let allNil = self.latitude == nil && self.longitude == nil
        let allSet = self.latitude != nil && self.longitude != nil
        guard allNil || allSet else {
            throw MyBMWError.invalidInitialization(
                thrower: self,
                description: "Either none or all arguments must be nil"
            )
        }
    }
}
