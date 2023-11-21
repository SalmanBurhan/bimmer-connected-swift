//
//  MyBMWAccount.swift
//  myBMW
//
//  Created by Salman Burhan on 11/19/23.
//

import Foundation

/// Create a new connection to the MyBMW web service.
public class MyBMWAccount {
    let username: String
    let password: String
    let region: MyBMWRegion
    let configuration: MyBMWClientConfiguration
    let client: MyBMWClient
    let useMetricUnits: Bool

    public init(
        username: String,
        password: String,
        region: MyBMWRegion,
        tokenData: MyBMWTokenData? = nil,
        useMetricUnits: Bool = true
    ) {
        self.username = username
        self.password = password
        self.region = region
        self.useMetricUnits = useMetricUnits
        self.configuration = MyBMWClientConfiguration(
            authentication: MyBMWAuthentication(
                username: username,
                password: password,
                region: region,
                tokenData: tokenData),
            observerPosition: nil,
            useMetricUnits: useMetricUnits)
        self.client = MyBMWClient(with: self.configuration)
    }
    
    /// Initialize vehicles from BMW servers.
    public func getVehicles() async throws {
        let dateFormatter = ISO8601DateFormatter()
        let currentDate = Date()
        
        let request = MyBMWRequest<Data>(
            endpoint: .Vehicle(.base),
            method: .get,
            headers: ["bmw-current-date": dateFormatter.string(from: currentDate)]
        )
        print(request)
        let (data, response) = try await client.response(for: request)
        print(String(data: data, encoding: .utf8))
    }
    
}
