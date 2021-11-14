//
//  UpdateRepository.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/13.
//

import Foundation

import RoutinusDatabase

protocol UpdateRepository {
    func fetchChallenge(challengeId: String) async -> Challenge?
    func update(challenge: Challenge)
}

extension RoutinusRepository: UpdateRepository {
    func fetchChallenge(challengeId: String) async -> Challenge? {
        guard let ownerID = RoutinusRepository.userID() else { return nil }
        guard let challengeDTO = try? await RoutinusDatabase.challenge(ownerId: ownerID, challengeId: challengeId) else { return nil }
        return Challenge(challengeDTO: challengeDTO)
    }

    func update(challenge: Challenge) {
        guard let startDate = challenge.startDate?.toString(), let endDate = challenge.endDate?.toString() else { return }
        let challengeDTO = ChallengeDTO(id: challenge.challengeID,
                                        title: challenge.title,
                                        imageURL: challenge.imageURL,
                                        authExampleImageURL: challenge.authExampleImageURL,
                                        authMethod: challenge.authMethod,
                                        categoryID: challenge.challengeID,
                                        week: challenge.week,
                                        decs: challenge.introduction,
                                        startDate: startDate,
                                        endDate: endDate,
                                        participantCount: challenge.participantCount,
                                        ownerID: challenge.ownerID,
                                        thumbnailImageURL: challenge.thumbnailImageURL)
        RoutinusDatabase.updateChallenge(challenge: challengeDTO)
    }
}
