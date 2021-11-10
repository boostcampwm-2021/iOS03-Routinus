//
//  ChallengeRepository.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/09.
//

import Foundation

import RoutinusDatabase

protocol ChallengeRepository {
    func fetchRecommendChallenge() async -> [Challenge]
}

extension RoutinusRepository: ChallengeRepository {
    func fetchRecommendChallenge() async -> [Challenge] {
        guard let list = try? await RoutinusDatabase.recommendChallenge() else { return [] }
        return list.map { Challenge(challengeDTO: $0) }
    }
}
