//
//  MyBMWLoginClient.swift
//  myBMW
//
//  Created by Salman Burhan on 11/14/23.
//

import Foundation

class MyBMWLoginClient {
    let constants: MyBMWConstants
    let session: URLSession
    
    init(_ region: MyBMWRegion) {
        self.constants = MyBMWConstants(carBrand: .BMW, region: region)
        self.session = URLSession(configuration: .default)
    }
    
    internal func configureSession() {
        self.session.configuration.timeoutIntervalForResource = 30 /// Seconds
        
        self.session.configuration.httpAdditionalHeaders = [
            "User-Agent": self.constants.userAgent,
            "X-User-Agent": self.constants.xUserAgent
        ]
    }
    
}
