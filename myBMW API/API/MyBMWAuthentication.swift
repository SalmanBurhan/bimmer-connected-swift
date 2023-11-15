//
//  MyBMWAuthentication.swift
//  myBMW
//
//  Created by Salman Burhan on 11/14/23.
//

import Foundation

/// Authentication and Retry Handler for MyBMW API.
class MyBMWAuthentication {
    let username: String
    let password: String
    let region: MyBMWRegion
    var access_token: String?
    var expires_at: Date?
    var refresh_token: String?
    var gcid: String?

    init(
        username: String,
        password: String,
        region: MyBMWRegion,
        access_token: String? = nil,
        expires_at: Date? = nil,
        refresh_token: String? = nil,
        gcid: String? = nil
    ) {
        self.username = username
        self.password = password
        self.region = region
        self.access_token = access_token
        self.expires_at = expires_at
        self.refresh_token = refresh_token
        self.gcid = gcid
    }
    
    func async_auth_flow() async {
        await self.login()
    }
    
    /// Get a valid OAuth token.
    func login() async {
        var token_data: MyBMWTokenData?
        switch self.region {
        case .NORTH_AMERICA, .REST_OF_WORLD:
            // Try logging in with refresh token first
            if let refresh_token = self.refresh_token {
                token_data = await self.refresh_token_row_na()
                if token_data == nil {
                    token_data = await self.login_row_na()
                }
            }
        }
        self.access_token = token_data?.access_token
        self.expires_at = token_data?.expires_at
        self.refresh_token = token_data?.refresh_token
    }
    
    // MARK: - Region Based Refresh Token Methods

    private func refresh_token_row_na() async -> MyBMWTokenData? {
        nil
    }

    private func refresh_token_china() async -> MyBMWTokenData? {
        nil
    }
    
    // MARK: - Region Based Login Methods
    
    /// Login to Rest of World and North America.
    private func login_row_na() async -> MyBMWTokenData? {
        nil
    }

    private func login_china() async -> MyBMWTokenData? {
        nil
    }
}
