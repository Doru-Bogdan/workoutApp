//
//  UserAccount.swift
//  QuickTrain-iOS
//

import Foundation

class UserAccount: Codable {
    var email: String?
    var firstName: String?
    var id: String?
    var imageURL: String?
    var lastName: String?
    var username: String?

    
    enum CodingKeys: String, CodingKey {
            case id
            case firstName = "first_name"
            case lastName = "last_name"
            case username, email
            case imageURL = "certificateUrl"
        }
}

struct Meta: Codable {
    let serverTime: String?
    let statusCode: Int?
    let message: String?
}

class GetAccountResponse: Codable {
    let data: UserAccount?
}
