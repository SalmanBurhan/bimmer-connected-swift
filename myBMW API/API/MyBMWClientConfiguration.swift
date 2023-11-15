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
    let log_responses: Bool? = false
    let observer_position: GPSPosition?
    let use_metric_units: Bool? = true
}
