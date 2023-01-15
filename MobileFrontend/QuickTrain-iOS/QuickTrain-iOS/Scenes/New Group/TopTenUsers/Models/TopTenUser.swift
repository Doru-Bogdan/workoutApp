//
//  TopTenUser.swift
//  QuickTrain-iOS
//
//  Created by Doru Mancila on 31.01.2021.
//

import Foundation

// MARK: -TopTenUser
struct TopTenUser: Codable {
    let currentPoints: Int?
    let firstName: String?
    let id: String?
    let lastName: String?
    let level: Int?
    
    enum CodingKeys: String, CodingKey {
        case currentPoints = "user_currentPoints"
        case firstName = "first_name"
        case id = "id"
        case lastName = "last_name"
        case level = "user_level"
    }
}

struct RankingResponse: Codable {
    let data: [TopTenUser]
}
