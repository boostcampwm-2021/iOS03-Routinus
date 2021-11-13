//
//  UpdateRepository.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/13.
//

import Foundation

import RoutinusDatabase

protocol UpdateRepository {
    func fetchChallenge(ownerId: String, challengeId: String) async -> Challenge?
    func update(challenge: ChallengeDTO)
}

extension RoutinusRepository: UpdateRepository {
    func fetchChallenge(ownerId: String, challengeId: String) async -> Challenge? {
        guard let challengeDTO = try? await RoutinusDatabase.challenge(ownerId: ownerId, challengeId: challengeId) else { return nil }
        return Challenge(challengeDTO: challengeDTO)
    }

    func update(challenge: ChallengeDTO) {
        RoutinusDatabase.updateChallenge(challenge: challenge)
    }
}
