//
//  ChallengeRepository.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/09.
//

import Foundation

import RoutinusDatabase

protocol ChallengeRepository {
    func fetchRecommendChallenge() async -> [RecommendChallenge]
}

extension RoutinusRepository: ChallengeRepository {
    func fetchRecommendChallenge() async -> [RecommendChallenge] {
        guard let list = try? await RoutinusDatabase.challengeInfo() else { return [] }
        return list.map { RecommendChallenge(challengeDTO: $0) }
    }
}
