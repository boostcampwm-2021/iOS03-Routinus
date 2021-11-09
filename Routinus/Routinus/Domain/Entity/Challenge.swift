//
//  Challenge.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/09.
//

import Foundation

import RoutinusDatabase

struct Challenge: Hashable {
    let challengeID: String
    let categoryID: String
    let title: String
    let description: String
    let participantCount: Int
    let thumbnailImageURL: URL?

    init(challengeID: String, categoryID: String, title: String, description: String,
         participantCount: Int, thumbnailImage: String) {
        self.challengeID = challengeID
        self.categoryID = categoryID
        self.title = title
        self.description = description
        self.participantCount = participantCount
        self.thumbnailImageURL = URL(string: thumbnailImage)
    }

    init(challengeDTO: ChallengeDTO) {
        self.challengeID = challengeDTO.id
        self.categoryID = challengeDTO.categoryID
        self.title = challengeDTO.title
        self.description = challengeDTO.desc
        self.participantCount = challengeDTO.participantCount
        self.thumbnailImageURL = URL(string: challengeDTO.thumbnailImageURL)
    }
}
