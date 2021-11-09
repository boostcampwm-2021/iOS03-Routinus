//
//  RecommendChallenge.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/08.
//

import Foundation

import RoutinusDatabase

struct RecommendChallenge: Hashable {
    let challengeID: String
    let title: String
    let description: String
    let participantCount: Int

    init(challengeID: String, title: String, description: String, participantCount: Int) {
        self.challengeID = challengeID
        self.title = title
        self.description = description
        self.participantCount = participantCount
    }

    init(challengeDTO: ChallengeDTO) {
        self.challengeID = challengeDTO.id
        self.title = challengeDTO.title
        self.description = challengeDTO.desc
        self.participantCount = challengeDTO.participantCount
    }
}
