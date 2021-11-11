//
//  ChallengeDTO.swift
//  RoutinusDatabase
//
//  Created by 박상우 on 2021/11/09.
//

import Foundation

public struct ChallengeDTO {
    public var id: String
    public var title: String
    public var imageURL: String
    public var authExampleImageURL: String
    public var authMethod: String
    public var categoryID: String
    public var week: Int
    public var desc: String
    public var startDate: String
    public var endDate: String
    public var participantCount: Int
    public var ownerID: String
    public var thumbnailImageURL: String

    public init() {
        self.id = ""
        self.title = ""
        self.imageURL = ""
        self.authExampleImageURL = ""
        self.authMethod = ""
        self.categoryID = ""
        self.week = 0
        self.desc = ""
        self.startDate = ""
        self.endDate = ""
        self.participantCount = 0
        self.ownerID = ""
        self.thumbnailImageURL = ""
    }

    public init(id: String, title: String, imageURL: String, authExampleImageURL: String,
                authMethod: String, categoryID: String, week: Int, decs: String, startDate: String,
                endDate: String, participantCount: Int, ownerID: String, thumbnailImageURL: String) {
        self.id = id
        self.title = title
        self.imageURL = imageURL
        self.authExampleImageURL = authExampleImageURL
        self.authMethod = authMethod
        self.categoryID = categoryID
        self.week = week
        self.desc = decs
        self.startDate = startDate
        self.endDate = endDate
        self.participantCount = participantCount
        self.ownerID = ownerID
        self.thumbnailImageURL = thumbnailImageURL
    }

    public init(challenge: [String: Any]?) {
        self.id = challenge?["id"] as? String ?? ""
        self.title = challenge?["title"] as? String ?? ""
        self.imageURL = challenge?["image_url"] as? String ?? ""
        self.authExampleImageURL = challenge?["auth_example_image_url"] as? String ?? ""
        self.authMethod = challenge?["auth_method"] as? String ?? ""
        self.categoryID = challenge?["category_id"] as? String ?? ""
        self.week = challenge?["week"] as? Int ?? 0
        self.desc = challenge?["desc"] as? String ?? ""
        self.startDate = challenge?["start_date"] as? String ?? ""
        self.endDate = challenge?["end_date"] as? String ?? ""
        self.participantCount = challenge?["participant_count"] as? Int ?? 0
        self.ownerID = challenge?["owner_id"] as? String ?? ""
        self.thumbnailImageURL = challenge?["thumbnail_image_url"] as? String ?? ""
    }
}
