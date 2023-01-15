//
//  GenericUser.swift
//  QuickTrain-iOS
//

import Foundation

struct GenericUser {
    let email: String?
    let username: String?
    let password: String?
    let firstName: String?
    let lastName: String?
}

extension GenericUser: Codable {
    enum CodingKeys: String, CodingKey {
        case email, password, firstName, lastName
        case username = "login"
    }
}
