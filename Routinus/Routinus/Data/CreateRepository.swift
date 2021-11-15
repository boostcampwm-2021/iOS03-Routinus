//
//  CreateRepository.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/09.
//

import Foundation

import RoutinusDatabase

protocol CreateRepository {
    func save(challenge: Challenge, imageURL: String, authImageURL: String)
}

extension RoutinusRepository: CreateRepository {
    func save(challenge: Challenge, imageURL: String, authImageURL: String) {
        guard let startDate = challenge.startDate?.toString(),
              let endDate = challenge.endDate?.toString() else { return }

        let challengeDTO = ChallengeDTO(id: challenge.challengeID,
                                        title: challenge.title,
                                        authMethod: challenge.authMethod,
                                        categoryID: challenge.category.id,
                                        week: challenge.week,
                                        desc: challenge.introduction,
                                        startDate: startDate,
                                        endDate: endDate,
                                        participantCount: 1,
                                        ownerID: challenge.ownerID)
        
        Task {
            try await RoutinusDatabase.createChallenge(challenge: challengeDTO,
                                                       imageURL: imageURL,
                                                       authImageURL: authImageURL)
        }
    }
}
