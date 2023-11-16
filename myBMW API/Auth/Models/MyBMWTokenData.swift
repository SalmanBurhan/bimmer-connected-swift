//
//  MyBMWTokenData.swift
//  myBMW
//
//  Created by Salman Burhan on 11/14/23.
//

import Foundation

struct MyBMWTokenData: Codable {
    let access_token: String?
    let expires_at: Date?
    let refresh_token: String?
    let gcid: String?
}
