//
//  MyBMWConstants.swift
//  myBMW
//
//  Created by Salman Burhan on 11/14/23.
//

import Foundation

struct MyBMWConstants {
    let region: MyBMWRegion
    let carBrand: MyBMWCarBrand
    
    init(carBrand: MyBMWCarBrand, region: MyBMWRegion) {
        self.region = region
        self.carBrand = carBrand
    }
    
    // MARK: - Header Related Constants
    
    /// Get the app version & build number for the region.
    var appVersion: String {
        switch region {
        case .NORTH_AMERICA: "3.9.0(27760)"
        case .REST_OF_WORLD: "3.9.0(27760)"
        //case .CHINA: "3.6.1(23634)"
        }
    }
    
    /// Get the Dart user agent for the region.
    var userAgent: String {
        switch region {
        case .NORTH_AMERICA: "Dart/2.19 (dart:io)"
        case .REST_OF_WORLD: "Dart/2.19 (dart:io)"
        //case .CHINA: "3.6.1(23634)"
        }
    }
    
    /// Get the authorization for OAuth settings.
    var ocpApimKey: String {
        switch region {
        case .NORTH_AMERICA: "31e102f5-6f7e-7ef3-9044-ddce63891362"
        case .REST_OF_WORLD: "4f1c85a3-758f-a37d-bbb6-f8704494acfa"
        //case .CHINA: ""
        }
    }
        
    var xUserAgent: String {
        return "android(TQ2A.230405.003.B2);\(carBrand.rawValue);\(appVersion);\(region.rawValue)"
    }
    
    // MARK: - URL Related Constants
    
    /// Get the url of the server for the region.
    var serverURL: String {
        switch region {
        case .NORTH_AMERICA: "https://cocoapi.bmwgroup.us"
        case .REST_OF_WORLD: "https://cocoapi.bmwgroup.com"
        //case .CHINA: "myprofile.bmw.com.cn"
        }
    }
}
