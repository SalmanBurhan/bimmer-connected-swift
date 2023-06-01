//
//  MyBMWLoginClient.swift
//  myBMW
//
//  Created by Salman Burhan on 5/22/23.
//

import Foundation
import CryptoKit
import Just

class MyBMWLoginClient {
    
    static let shared = MyBMWLoginClient()
    
    private let oauthConfig = MyBMWOAuthConfig.shared
    private var headers = [String: String]()

    private let codeVerifier: String
    
    private init() {
        self.codeVerifier = MyBMWLoginClient.generateToken(length: 86)
        self.setClientID()
        self.setResponseType()
        self.setRedirectURI()
        self.setState()
        self.setNonce()
        self.setScope()
        self.setCodeChallenge()
        self.setCodeChallengeMethod()
    }
    
    private func setClientID() {
        self.headers["client_id"] = self.oauthConfig.clientID
    }
    
    private func setResponseType() {
        self.headers["response_type"] = "code"
    }
    
    private func setRedirectURI() {
        self.headers["redirect_uri"] = self.oauthConfig.returnURL
    }
    
    private func setState() {
        self.headers["state"] = MyBMWLoginClient.generateToken(length: 22)
    }
    
    private func setNonce() {
        self.headers["nonce"] = "login_nonce"
    }
    
    private func setScope() {
        self.headers["scope"] = self.oauthConfig.scopes?.joined(separator: " ")
    }
    
    private func setCodeChallenge() {
        self.headers["code_challenge"] = MyBMWLoginClient.generateCodeChallenge(self.codeVerifier)
    }
    
    private func setCodeChallengeMethod() {
        self.headers["code_challenge_method"] = "S256"
    }
        
    private func authenticate(username: String, password: String) -> String? {
        guard let authenticate_url = self.oauthConfig.tokenEndpoint?.replacingOccurrences(of: "/token", with: "/authenticate")
        else { return nil }
        var data = self.headers
        data["grant_type"] = "authorization_code"
        data["username"] = username
        data["password"] = password
        let request = Just.post(authenticate_url, data: data)
        guard request.statusCode == 200,
              let r = request.json as? [String: String]
        else { return nil }
        var components = URLComponents()
        components.query = r["redirect_to"]
        let authorization = components.queryItems?.first(where: { $0.name == "authorization" })
        return authorization?.value
    }
        
    
    private static func generateToken(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    private static func generateCodeChallenge(_ codeVerifier: String) -> String {
        let inputData = codeVerifier.data(using: .ascii)!
        let hashed = SHA256.hash(data: inputData)
        return Data(hashed).base64EncodedString()
    }
}
