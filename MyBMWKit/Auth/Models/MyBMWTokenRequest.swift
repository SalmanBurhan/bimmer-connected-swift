//
//  MyBMWTokenRequest.swift
//  myBMW
//
//  Created by Salman Burhan on 11/19/23.
//

import Foundation

fileprivate struct MyBMWBaseTokenRequest {
    let clientID: String
    let clientSecret: String
    let grantType: String
    let redirectURI: URL
    let url: URL
    
    init(from openIDConfiguration: MyBMWOpenIDConnectConfig, grantType: String) {
        self.redirectURI = openIDConfiguration.returnURL
        self.clientID = openIDConfiguration.clientID
        self.clientSecret = openIDConfiguration.clientSecret
        self.url = openIDConfiguration.tokenEndpoint
        self.grantType = grantType
    }
    
    var queryItems: [URLQueryItem] {
        return [
            .init(name: CodingKeys.redirectURI.stringValue, value: redirectURI.absoluteString),
            .init(name: CodingKeys.grantType.stringValue, value: grantType)
        ]
    }
    
    func generateAuthorizationHeader() throws -> [String: String] {
        guard let data = "\(self.clientID):\(self.clientSecret)".data(using: .utf8)
        else {
            throw MyBMWAuthenticationError.encodingError(
                description: "An error occurred converting Client ID and Secret Strings to Data Representation.")
        }
        return ["Authorization": "Basic \(data.base64EncodedString())"]
    }

    enum CodingKeys: String, CodingKey {
        case redirectURI = "redirect_uri"
        case grantType = "grant_type"
    }

}

internal struct MyBMWRefreshTokenRequest {
    fileprivate let baseRequest: MyBMWBaseTokenRequest
    let refreshToken: String
    let scope: String
    
    init(from openIDConfiguration: MyBMWOpenIDConnectConfig, refreshToken: String) {
        self.baseRequest = .init(from: openIDConfiguration, grantType: "refresh_token")
        self.refreshToken = refreshToken
        self.scope = openIDConfiguration.scopes.joined(separator: " ")
    }
    
    var queryItems: [URLQueryItem] {
        var queryItems: [URLQueryItem] = [
            .init(name: CodingKeys.refreshToken.stringValue, value: refreshToken),
            .init(name: CodingKeys.scope.stringValue, value: scope),
        ]
        queryItems.append(contentsOf: self.baseRequest.queryItems)
        return queryItems
    }
    
    var percentEncodedQueryItems: String? {
        var components = URLComponents()
        components.queryItems = self.queryItems
        return components.percentEncodedQuery
    }

    func buildRequest() throws -> MyBMWRequest<MyBMWTokenData> {
        return MyBMWRequest<MyBMWTokenData>(
            url: self.baseRequest.url,
            method: .post,
            headers: try self.baseRequest.generateAuthorizationHeader(),
            body: self.percentEncodedQueryItems?.data(using: .utf8)
        )
    }

    enum CodingKeys: String, CodingKey {
        case refreshToken = "refresh_token"
        case scope
    }
}

internal struct MyBMWAccessTokenRequest {
    fileprivate let baseRequest: MyBMWBaseTokenRequest
    let codeVerifier: String
    let code: String
    
    init(from openIDConfiguration: MyBMWOpenIDConnectConfig, code: String, codeVerifier: String) {
        self.baseRequest = .init(from: openIDConfiguration, grantType: "authorization_code")
        self.code = code
        self.codeVerifier = codeVerifier
    }
    
    var queryItems: [URLQueryItem] {
        var queryItems: [URLQueryItem] = [
            .init(name: CodingKeys.code.stringValue, value: code),
            .init(name: CodingKeys.codeVerifier.stringValue, value: codeVerifier),
        ]
        queryItems.append(contentsOf: self.baseRequest.queryItems)
        return queryItems
    }
    
    var percentEncodedQueryItems: String? {
        var components = URLComponents()
        components.queryItems = self.queryItems
        return components.percentEncodedQuery
    }
    
    func buildRequest() throws -> MyBMWRequest<MyBMWTokenData> {
        return MyBMWRequest<MyBMWTokenData>(
            url: self.baseRequest.url,
            method: .post,
            headers: try self.baseRequest.generateAuthorizationHeader(),
            body: self.percentEncodedQueryItems?.data(using: .utf8)
        )
    }

    enum CodingKeys: String, CodingKey {
        case codeVerifier = "code_verifier"
        case code
    }
}

public struct MyBMWTokenRequest_ {
    
    public let code: String
    public let codeVerifier: String
    public let redirectURI: URL
    public let grantType: String
    
    private let clientID: String
    private let clientSecret: String
    
    private let url: URL
    
    init(from openIDConfiguration: MyBMWOpenIDConnectConfig,
         code: String,
         codeVerifier: String,
         grantType: String = "authorization_code"
    ) {
        self.code = code
        self.codeVerifier = codeVerifier
        self.redirectURI = openIDConfiguration.returnURL
        self.grantType = grantType
        self.clientID = openIDConfiguration.clientID
        self.clientSecret = openIDConfiguration.clientSecret
        self.url = openIDConfiguration.tokenEndpoint
    }
    
    public func asQueryItems() -> [URLQueryItem] {
        return [
            URLQueryItem(name: CodingKeys.code.stringValue, value: code),
            URLQueryItem(name: CodingKeys.codeVerifier.stringValue, value: codeVerifier),
            URLQueryItem(name: CodingKeys.redirectURI.stringValue, value: redirectURI.absoluteString),
            URLQueryItem(name: CodingKeys.grantType.stringValue, value: grantType)
        ]
    }
    
    public func asPercentEncodedQueryItems() -> String? {
        var components = URLComponents()
        components.queryItems = self.asQueryItems()
        return components.percentEncodedQuery
    }
    
    private func encodedCredentials() throws -> String {
        guard let data = "\(self.clientID):\(self.clientSecret)".data(using: .utf8)
        else {
            throw MyBMWAuthenticationError.encodingError(
                description: "An error occurred converting Client ID and Secret Strings to Data Representation.")
        }
        return data.base64EncodedString()
    }

    public func asMyBMWRequest() throws -> MyBMWRequest<MyBMWTokenData> {
        return MyBMWRequest<MyBMWTokenData>(
            url: self.url,
            method: .post,
            headers: ["Authorization": "Basic \(try self.encodedCredentials())"],
            body: self.asPercentEncodedQueryItems()?.data(using: .utf8)
        )
    }

    private enum CodingKeys: String, CodingKey {
        case code
        case codeVerifier = "code_verifier"
        case redirectURI = "redirect_uri"
        case grantType = "grant_type"
    }
}
