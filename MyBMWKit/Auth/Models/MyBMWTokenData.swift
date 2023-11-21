//
//  MyBMWTokenData.swift
//  myBMW
//
//  Created by Salman Burhan on 11/14/23.
//

import Foundation

public struct MyBMWTokenData: Codable {
    let accessToken: String
    let expiration: Date
    let refreshToken: String
    let gcid: String?
    
    public var isExpired: Bool {
        return Date() > self.expiration
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.accessToken = try container.decode(String.self, forKey: .accessToken)
        self.refreshToken = try container.decode(String.self, forKey: .refreshToken)
        self.gcid = try container.decodeIfPresent(String.self, forKey: .gcid)
        
        let expiresIn = try container.decode(Double.self, forKey: .expiration)
        self.expiration = Date(timeIntervalSinceNow: expiresIn)
    }

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiration = "expires_in"
        case refreshToken = "refresh_token"
        case gcid = "gcid"
    }
}
