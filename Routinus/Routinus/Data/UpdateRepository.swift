//
//  UpdateRepository.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/13.
//

import Foundation

import RoutinusDatabase

protocol UpdateRepository {
    func fetchChallenge(challengeID: String) async -> Challenge?
    func update(challenge: Challenge) async
}

extension RoutinusRepository: UpdateRepository {
    func fetchChallenge(challengeID: String) async -> Challenge? {
        guard let ownerID = RoutinusRepository.userID() else { return nil }
        guard let challengeDTO = try? await RoutinusDatabase.challenge(ownerID: ownerID, challengeID: challengeID) else { return nil }
        return Challenge(challengeDTO: challengeDTO)
    }

    func update(challenge: Challenge) async {
        guard let startDate = challenge.startDate?.toString(), let endDate = challenge.endDate?.toString() else { return }
        let challengeDTO = ChallengeDTO(id: challenge.challengeID,
                                        title: challenge.title,
                                        authMethod: challenge.authMethod,
                                        categoryID: challenge.category.id,
                                        week: challenge.week,
                                        desc: challenge.introduction,
                                        startDate: startDate,
                                        endDate: endDate,
                                        participantCount: challenge.participantCount,
                                        ownerID: challenge.ownerID)
        try? await RoutinusDatabase.updateChallenge(challengeDTO: challengeDTO)
    }
}
