//
//  ChallengeRepository.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/09.
//

import Foundation

import RoutinusDatabase

protocol ChallengeRepository {
    func fetchRecommendChallenges() async -> [Challenge]
}

extension RoutinusRepository: ChallengeRepository {
    func fetchRecommendChallenges() async -> [Challenge] {
        guard let list = try? await RoutinusDatabase.recommendChallenges() else { return [] }
        return list.map { Challenge(challengeDTO: $0) }
    }
}
