//
//  MyBMWOAuth2Settings.swift
//  myBMW
//
//  Created by Salman Burhan on 11/15/23.
//

import Foundation

// MARK: - MyBMWOAuth2Settings

public struct MyBMWOAuth2Settings: Codable {
    public let clientName: String
    public let clientSecret: String
    public let clientID: String
    public let gcdmBaseURL: String
    public let returnURL: String
    public let brand: String
    public let language: String
    public let country: String
    public let authorizationEndpoint: String
    public let tokenEndpoint: String
    public let scopes: [String]
    public let promptValues: [String]

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

    public init(
        clientName: String,
        clientSecret: String,
        clientID: String,
        gcdmBaseURL: String,
        returnURL: String,
        brand: String,
        language: String,
        country: String,
        authorizationEndpoint: String,
        tokenEndpoint: String,
        scopes: [String],
        promptValues: [String]
    ) {
        self.clientName = clientName
        self.clientSecret = clientSecret
        self.clientID = clientID
        self.gcdmBaseURL = gcdmBaseURL
        self.returnURL = returnURL
        self.brand = brand
        self.language = language
        self.country = country
        self.authorizationEndpoint = authorizationEndpoint
        self.tokenEndpoint = tokenEndpoint
        self.scopes = scopes
        self.promptValues = promptValues
    }
}
