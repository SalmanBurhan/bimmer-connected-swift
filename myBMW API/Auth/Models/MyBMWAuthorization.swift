//
//  MyBMWAuthorization.swift
//  myBMW
//
//  Created by Salman Burhan on 11/15/23.
//

import Foundation

public struct MyBMWAuthorization: Decodable {
    public let redirectURI: String
    public let responseType: String
    public let scope: String
    public let authorization: String
    
    private enum CodingKeys: String, CodingKey {
        case redirectTo = "redirect_to"
        case redirectURI = "redirect_uri"
        case responseType = "response_type"
        case scope
        case authorization
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let redirectTo = try container.decode(String.self, forKey: .redirectTo)
        let components = URLComponents(string: "?\(redirectTo)")!
        self.redirectURI = components.queryItems!.first(where: { $0.name == CodingKeys.redirectURI.stringValue })!.value!
        self.responseType = components.queryItems!.first(where: { $0.name == CodingKeys.responseType.stringValue })!.value!
        self.scope = components.queryItems!.first(where: { $0.name == CodingKeys.scope.stringValue })!.value!
        self.authorization = components.queryItems!.first(where: { $0.name == CodingKeys.authorization.stringValue })!.value!
    }
}
