//
//  VideoThumbnail.swift
//  QuickTrain-iOS
//
//  Created by Doru Mancila on 20.12.2020.
//

import Foundation

class VideoThumbnail: Codable {
    
    var id: String?
    var thumbnailUrl: String?
    var title: String?
    var requiredXp: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case thumbnailUrl = "workoutThumbnailUrl"
        case title = "workoutTitle"
        case requiredXp = "workoutRequiredXp"
    }
    
    init(id: String, thumbnailUrl: String) {
        self.id = id
        self.thumbnailUrl = thumbnailUrl
    }
}
