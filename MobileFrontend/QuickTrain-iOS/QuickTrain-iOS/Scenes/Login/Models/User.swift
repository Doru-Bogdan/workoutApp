//
//  User.swift
//  QuickTrain-iOS
//

import Foundation

//struct User: Codable {
//    let certificateURL: String?
//    var currentPoints: Int?
//    let  id: Int?
//    var level: Int?
//    let userID: Int?
//
//
//    enum CodingKeys: String, CodingKey {
//        case certificateURL = "certificateUrl"
//        case currentPoints, id, level
//        case userID = "userId"
//    }
//}

struct GetUserResponse: Codable {
    let user: User?
    enum CodingKeys: String, CodingKey {
        case user = "data"
    }
}

// MARK: - DataClass
class User: Codable {
    var id: String?
    var firstName: String?
    var lastName: String?
    var username: String?
    var email: String?
    var certificateURL: String?
    var level: Int?
    var currentPoints: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case username, email
        case certificateURL = "certificateUrl"
        case currentPoints, level
    }
}
