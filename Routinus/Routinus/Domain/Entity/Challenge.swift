//
//  Challenge.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/08.
//

import Foundation

import RoutinusDatabase

struct Challenge: Hashable {
    let challengeID: String
    let title: String
    let description: String
    let category: Category
    let imageURL: String
    let authExampleImageURL: String
    let thumbnailImageURL: String
    let authMethod: String
    let startDate: Date?
    let endDate: Date?
    let ownerID: String
    let week: Int
    let participantCount: Int

    init(challengeID: String, title: String, description: String, category: Category, imageURL: String,
         authExampleImageURL: String, thumbnailImageURL: String, authMethod: String, startDate: Date,
         endDate: Date, ownerID: String, week: Int, participantCount: Int) {
        self.challengeID = challengeID
        self.title = title
        self.description = description
        self.category = category
        self.imageURL = imageURL
        self.authExampleImageURL = authExampleImageURL
        self.thumbnailImageURL = thumbnailImageURL
        self.authMethod = authMethod
        self.startDate = startDate
        self.endDate = endDate
        self.ownerID = ownerID
        self.week = week
        self.participantCount = participantCount
    }

    init(challengeDTO: ChallengeDTO) {
        self.challengeID = challengeDTO.id
        self.title = challengeDTO.title
        self.description = challengeDTO.desc
        self.category = Category.category(by: challengeDTO.categoryID)
        self.imageURL = challengeDTO.imageURL
        self.authExampleImageURL = challengeDTO.authExampleImageURL
        self.thumbnailImageURL = challengeDTO.thumbnailImageURL
        self.authMethod = challengeDTO.authMethod
        self.startDate = Date.toDate(challengeDTO.startDate)
        self.endDate = Date.toDate(challengeDTO.endDate)
        self.ownerID = challengeDTO.ownerID
        self.week = challengeDTO.week
        self.participantCount = challengeDTO.participantCount
    }
}
