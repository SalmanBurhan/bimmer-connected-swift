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
    var sessionID: String
    
    var tokenData: MyBMWTokenData? {
        didSet {
            guard let _ = tokenData else {
                self.logger.info("Access Token Removed")
                return
            }
            self.logger.info("Access Token Set")
        }
    }
    
    lazy var logger: MyBMWLogger = {
        return MyBMWLogger(MyBMWAuthentication.self)
    }()
    
    init(
        username: String,
        password: String,
        region: MyBMWRegion,
        tokenData: MyBMWTokenData? = nil)
    {
        self.username = username
        self.password = password
        self.region = region
        self.tokenData = tokenData
        self.sessionID = UUID().uuidString
    }
        
    /// Get a valid OAuth token.
    public func login() async {
        switch self.region {
        case .NORTH_AMERICA, .REST_OF_WORLD:
            // Try logging in with refresh token first
            guard let _ = tokenData else {
                self.tokenData = try? await self.login_row_na()
                return
            }
            self.tokenData = try? await self.refresh_token_row_na()
        }
    }
    
    // MARK: - Region Based Refresh Token Methods
    
    /// Login to Rest of World and North America using existing refreshToken.
    private func refresh_token_row_na() async throws -> MyBMWTokenData? {
        self.logger.info("Using Refresh Token to Update Stored Access Token")
        guard let refreshToken = self.tokenData?.refreshToken else { return nil }
        
        let client = MyBMWLoginClient(self.region)

        // Get OpenID Connect Configuration Document from BMW API.
        let openIDConfig = try await self.openIDConnectDocument(with: client).value

        // With code, get token.
        let tokenRequest = MyBMWRefreshTokenRequest(from: openIDConfig, refreshToken: refreshToken)
        let tokenData = try await self.getAccessToken(with: client, request: tokenRequest.buildRequest())
        
        return tokenData
    }
    
    // MARK: - Region Based Login Methods
    
    /// Login to Rest of World and North America.
    private func login_row_na() async throws -> MyBMWTokenData? {
        self.logger.info("Logging In To Retrieve New Access Token")
        let client = MyBMWLoginClient(self.region)
        
        // Get OpenID Connect Configuration Document from BMW API.
        let openIDConfig = try await self.openIDConnectDocument(with: client).value
        
        // Generate OAuth2 Code Challenge + State
        let (codeVerifier, codeChallenge, state) = self.createAuthenticationChallenge()
        
        // Set up authenticate endpoint.
        guard var authenticationURLComponents = URLComponents(
            url: openIDConfig.tokenEndpoint, resolvingAgainstBaseURL: false)
        else {
            return nil
        }
        
        let newPath = authenticationURLComponents.path.replacingOccurrences(of: "/token", with: "/authenticate")
        authenticationURLComponents.path = newPath
        
        guard let authenticationURL = authenticationURLComponents.url
        else {
            return nil
        }
        
        let oAuth2Settings = MyBMWOAuth2Settings(
            from: openIDConfig, state: state, codeChallenge: codeChallenge)
        
        // Call authenticate endpoint first time (with user/pw) and get authentication
        let authorization = try await self.authenticate(
            with: client, url: authenticationURL, settings: oAuth2Settings)
        
        // With authorization, call authenticate endpoint second time to get code.
        let authorizationCode = try await self.getAuthorizationCode(
            with: client, url: authenticationURL, settings: oAuth2Settings, authorization: authorization)
        
        // With code, get token.
        let tokenRequest = MyBMWAccessTokenRequest(from: openIDConfig, code: authorizationCode, codeVerifier: codeVerifier)
        let tokenData = try await self.getAccessToken(with: client, request: tokenRequest.buildRequest())
        
        return tokenData
    }
    
    /// Get OpenID Connect Configuration Document from BMW API.
    private func openIDConnectDocument(
        with client: MyBMWLoginClient
    ) async throws -> MyBMWResponse<MyBMWOpenIDConnectConfig> {
        var headers = MyBMWUtils.generateCorrelationHeaders()
        headers["ocp-apim-subscription-key"] = client.constants.ocpApimKey
        headers["bmw-session-id"] = self.sessionID
        return try await client.send(MyBMWRequest<MyBMWOpenIDConnectConfig>(
            endpoint: .oAuthConfiguration, method: .get, headers: headers))
    }
    
    /// Call authenticate endpoint first time (with user/pw) and get authentication
    private func authenticate(
        with client: MyBMWLoginClient,
        url: URL,
        settings: MyBMWOAuth2Settings) async throws -> MyBMWAuthorization
    {
        var newSettings = settings
        newSettings.grantType = "authorization_code"
        newSettings.username = self.username
        newSettings.password = self.password
        
        return try await client.send(
            MyBMWRequest<MyBMWAuthorization>(
                url: url,
                method: .post,
                body: newSettings.asPercentEncodedQueryItems()?.data(using: .utf8))
        ).value
    }
    
    /// With authorization, call authenticate endpoint second time to get code.
    private func getAuthorizationCode(
        with client: MyBMWLoginClient,
        url: URL,
        settings: MyBMWOAuth2Settings,
        authorization: MyBMWAuthorization) async throws -> String
    {
        var newSettings = settings
        newSettings.authorization = authorization.authorization
        
        let redirectionURL = try await client.captureRedirect(
            MyBMWRequest<URL>(
                url: url,
                method: .post,
                body: newSettings.asPercentEncodedQueryItems()?.data(using: .utf8)))
        
        let components = URLComponents(url: redirectionURL, resolvingAgainstBaseURL: true)
        
        guard let authorizationCode = components?.queryItems?.first(where: { $0.name == "code" })?.value
        else {
            throw MyBMWAuthenticationError.authorizationCodeExtractionError
        }
        
        return authorizationCode
    }
    
    /// With code, get token.
    private func getAccessToken(
        with client: MyBMWLoginClient,
        request: MyBMWRequest<MyBMWTokenData>) async throws -> MyBMWTokenData
    {
        let response = try await client.send(request)
        return response.value
    }
    
    
    private func createAuthenticationChallenge()
    -> (verifier: String, challenge: String, state: String)
    {
        let codeVerifier = MyBMWUtils.generateToken(length: 86)
        let codeChallenge = MyBMWUtils.createS256CodeChallenge(from: codeVerifier)
        let state = MyBMWUtils.generateToken(length: 22)
        
        return (verifier: codeVerifier, challenge: codeChallenge, state: state)
    }

}
