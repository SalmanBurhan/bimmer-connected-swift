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
            if self.refresh_token != nil {
                token_data = await self.refresh_token_row_na()
            }
            if token_data == nil {
                token_data = try? await self.login_row_na()
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
    private func login_row_na() async throws -> MyBMWTokenData? {
        let client = MyBMWLoginClient(self.region)
        /// Get OAuth2 settings from BMW API.
        let oAuth2Settings = try await self.oAuth2Settings(with: client).value
        /// Generate OAuth2 Code Challenge + State
        let codeVerifier = MyBMWUtils.generateToken(length: 86)
        let codeChallenge = MyBMWUtils.createS256CodeChallenge(from: codeVerifier)
        let state = MyBMWUtils.generateToken(length: 22)
        
        /// Set up authenticate endpoint.
        let authenticationURL = oAuth2Settings.tokenEndpoint

        return nil
    }
    
    /// Get OAuth2 settings from BMW API.
    private func oAuth2Settings(with client: MyBMWLoginClient) async throws -> MyBMWResponse<MyBMWOAuth2Settings> {
        var headers = MyBMWUtils.generateCorrelationHeaders()
        headers["ocp-apim-subscription-key"] = client.constants.ocpApimKey
        headers["bmw-session-id"] = UUID().uuidString
        return try await client.send(MyBMWRequest<MyBMWOAuth2Settings>(
            endpoint: .oAuthConfiguration, method: .get, headers: headers))
    }

    private func login_china() async -> MyBMWTokenData? {
        nil
    }
}
