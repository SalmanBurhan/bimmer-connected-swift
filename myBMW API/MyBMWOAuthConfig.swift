//
//  MyBMWOAuthConfig.swift
//  myBMW
//
//  Created by Salman Burhan on 5/22/23.
//

import Foundation
import Just

class MyBMWOAuthConfig {

    static let shared = MyBMWOAuthConfig()
    
    private let sessionID = UUID().uuidString
    private let correlationID = UUID().uuidString
    
    private let url = "https://\(MyBMWConstants.SERVER_URL.rawValue)\(MyBMWConstants.OAUTH_CONFIG_URL.rawValue)"
    private var headers = [String: String]()

    var clientName: String?
    var clientSecret: String?
    var clientID: String?
    var gcdmBaseURL: String?
    var returnURL: String?
    var brand: String?
    var langauge: String?
    var country: String?
    var authorizationEndpoint: String?
    var tokenEndpoint: String?
    var scopes: [String]?
    var promptValues: [String]?
        
    private init() {
        self.setUserAgent()
        self.setXUserAgent()
        self.setSubscriptionKey()
        self.setSessionID()
        self.setCorrelationID()
        self.get()
    }
    
    private func get() {
        let request = Just.get(self.url, headers: self.headers)
        guard request.statusCode == 200,
              let data = request.content,
              let r = try? JSONDecoder().decode(MyBMWOAuthConfigResponse.self, from: data)
        else { return }
        self.clientName = r.clientName
        self.clientSecret = r.clientSecret
        self.clientID = r.clientID
        self.gcdmBaseURL = r.gcdmBaseURL
        self.returnURL = r.returnURL
        self.brand = r.brand
        self.langauge = r.language
        self.country = r.country
        self.authorizationEndpoint = r.authorizationEndpoint
        self.tokenEndpoint = r.tokenEndpoint
        self.scopes = r.scopes
        self.promptValues = r.promptValues
    }
    
    private func setUserAgent() {
        self.headers["user-agent"] = MyBMWConstants.USER_AGENT.rawValue
    }
    
    private func setXUserAgent() {
        let parts: [MyBMWConstants] = [.X_USER_AGENT, .BRAND, .APP_VERSION, .REGION]
        self.headers["x-user-agent"] = parts.map({ $0.rawValue }).joined(separator: ";")
    }
    
    private func setSubscriptionKey() {
        self.headers["ocp-apim-subscription-key"] = MyBMWConstants.OCP_API_KEY.rawValue
    }
    
    private func setSessionID() {
        self.headers["bmw-session-id"] = self.sessionID
    }
    
    private func setCorrelationID() {
        self.headers["x-identity-provider"] = "gcdm"
        self.headers["x-correlation-id"] = self.correlationID
        self.headers["bmw-correlation-id"] = self.correlationID
    }
}

struct MyBMWOAuthConfigResponse: Decodable {
    let clientName: String
    let clientSecret: String
    let clientID: String
    let gcdmBaseURL: String
    let returnURL: String
    let brand: String
    let language: String
    let country: String
    let authorizationEndpoint: String
    let tokenEndpoint: String
    let scopes: [String]
    let promptValues: [String]
    
    enum CodingKeys: String, CodingKey {
        case clientName
        case clientSecret
        case clientID = "clientId"
        case gcdmBaseURL = "gcdmBaseUrl"
        case returnURL = "returnUrl"
        case brand
        case language
        case country
        case authorizationEndpoint
        case tokenEndpoint
        case scopes
        case promptValues
    }
}
