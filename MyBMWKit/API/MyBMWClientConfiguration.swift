//
//  MyBMWClientConfiguration.swift
//  myBMW
//
//  Created by Salman Burhan on 11/14/23.
//

import Foundation

/// Stores global settings for MyBMWClient.
struct MyBMWClientConfiguration {

    let authentication: MyBMWAuthentication
    let logResponses: Bool
    let observerPosition: GPSPosition?
    let useMetricUnits: Bool
    
    init(authentication: MyBMWAuthentication,
         logResponses: Bool = false,
         observerPosition: GPSPosition?,
         useMetricUnits: Bool = true) {
        self.authentication = authentication
        self.logResponses = logResponses
        self.observerPosition = observerPosition
        self.useMetricUnits = useMetricUnits
    }
}
