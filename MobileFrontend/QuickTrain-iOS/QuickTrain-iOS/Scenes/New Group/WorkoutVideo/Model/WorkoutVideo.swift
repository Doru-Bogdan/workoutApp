//
//  WorkoutVideo.swift
//  QuickTrain-iOS
//
//  Created by Doru Mancila on 22.12.2020.
//

import Foundation

struct WorkoutVideo: Codable {
    let createdAt, description: String?
    let id: String?
    let thumbnailURL, title, updatedAt, videoURL: String?
    let workoutTypeID, xpRequired, xpValue: Int?

    enum CodingKeys: String, CodingKey {
        case createdAt
        case description = "workoutDescription"
        case id
        case thumbnailURL = "workoutThumbnailUrl"
        case title = "workoutTitle"
        case updatedAt
        case videoURL = "workoutVideoUrl"
        case workoutTypeID = "workoutTypeId"
        case xpRequired = "workoutRequiredXp"
        case xpValue = "workoutValueXp"
    }
    
    init(createdAt: String? = nil,
         description: String? = nil,
         id: String? = nil,
         thumbnailURL: String? = nil,
         title: String? = nil,
         updatedAt: String? = nil,
         videoURL: String? = nil,
         workoutTypeID: Int? = nil,
         xpRequired: Int? = nil,
         xpValue: Int? = nil) {
        self.createdAt = createdAt
        self.description = description
        self.id = id
        self.thumbnailURL = thumbnailURL
        self.title = title
        self.updatedAt = updatedAt
        self.videoURL = videoURL
        self.workoutTypeID = workoutTypeID
        self.xpRequired = xpRequired
        self.xpValue = xpValue
    }
}
