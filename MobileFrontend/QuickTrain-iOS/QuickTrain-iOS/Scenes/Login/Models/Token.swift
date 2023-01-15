//
//  Token.swift
//  QuickTrain-iOS
//

import Foundation

enum TokenType {
    case bearer(token: String)
    case unauthorized
}

struct Token: Codable {

    var bearerToken: String?

    enum CodingKeys: String, CodingKey {
        case bearerToken = "access_token"
    }

    init(bearerToken: String) {
        self.bearerToken = bearerToken
    }

    func type() -> TokenType {
        if let token = bearerToken {
            return .bearer(token: token)
        }
        return .unauthorized
    }
}

struct LoginResponse: Codable {
    let data: DataClass
}

struct DataClass: Codable {
    let token: Token
}
