//
//  MyBMWOAuth2Settings.swift
//  myBMW
//
//  Created by Salman Burhan on 11/15/23.
//

import Foundation

// MARK: - MyBMWOAuth2Settings

public struct MyBMWOAuth2Settings {
    public let clientID: String
    public let responseType: String
    public let redirectURI: URL
    public let state: String
    public let nonce: String
    public let scope: String
    public let codeChallenge: String
    public let codeChallengeMethod: String
    
    public var grantType: String?
    public var username: String?
    public var password: String?
    public var authorization: String?
    
    init(clientID: String,
        responseType: String = "code",
        redirectURI: URL,
        state: String,
        nonce: String = "login_nonce",
        scope: String,
        codeChallenge: String,
        codeChallengeMethod: String = "S256"
    ) {
        self.clientID = clientID
        self.responseType = responseType
        self.redirectURI = redirectURI
        self.state = state
        self.nonce = nonce
        self.scope = scope
        self.codeChallenge = codeChallenge
        self.codeChallengeMethod = codeChallengeMethod
    }
    
    init(from openIDConfiguration: MyBMWOpenIDConnectConfig,
         state: String,
         codeChallenge: String
    ) {
        self.init(
            clientID: openIDConfiguration.clientID,
            redirectURI: openIDConfiguration.returnURL,
            state: state,
            scope: openIDConfiguration.scopes.joined(separator: " "),
            codeChallenge: codeChallenge
        )
    }
    
    public func asQueryItems() -> [URLQueryItem] {
        var queryItems = [
            URLQueryItem(name: CodingKeys.clientID.stringValue, value: clientID),
            URLQueryItem(name: CodingKeys.responseType.stringValue, value: responseType),
            URLQueryItem(name: CodingKeys.redirectURI.stringValue, value: redirectURI.absoluteString),
            URLQueryItem(name: CodingKeys.state.stringValue, value: state),
            URLQueryItem(name: CodingKeys.nonce.stringValue, value: nonce),
            URLQueryItem(name: CodingKeys.scope.stringValue, value: scope),
            URLQueryItem(name: CodingKeys.codeChallenge.stringValue, value: codeChallenge),
            URLQueryItem(name: CodingKeys.codeChallengeMethod.stringValue, value: codeChallengeMethod)
        ]
        if let grantType = grantType, let username = username, let password = password {
            queryItems.append(URLQueryItem(name: "grant_type", value: grantType))
            queryItems.append(URLQueryItem(name: "username", value: username))
            queryItems.append(URLQueryItem(name: "password", value: password))
        }
        else if let authorization = authorization {
            queryItems.append(URLQueryItem(name: "authorization", value: authorization))
        }
        return queryItems
        
    }
    
    public func asPercentEncodedQueryItems() -> String? {
        var components = URLComponents()
        components.queryItems = self.asQueryItems()
        return components.percentEncodedQuery
    }
    
    private enum CodingKeys: String, CodingKey {
        case clientID = "client_id"
        case responseType = "response_type"
        case redirectURI = "redirect_uri"
        case state
        case nonce
        case scope
        case codeChallenge = "code_challenge"
        case codeChallengeMethod = "code_challenge_method"
    }
    
}
