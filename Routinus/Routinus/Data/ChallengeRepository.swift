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
    func fetchSearchChallengesBy(keyword: String) async -> [Challenge]
    func fetchSearchChallengesBy(categoryID: String) async -> [Challenge]
    func fetchLatestChallenges() async -> [Challenge]
    func fetchChallenges(by userID: String) async -> [Challenge]
}

extension RoutinusRepository: ChallengeRepository {
    func fetchRecommendChallenges() async -> [Challenge] {
        guard let list = try? await RoutinusDatabase.recommendChallenges() else { return [] }
        return list.map { Challenge(challengeDTO: $0) }
    }

    func fetchSearchChallengesBy(keyword: String) async -> [Challenge] {
        guard let list = try? await RoutinusDatabase.latestChallenges() else { return [] }
        return list.map { Challenge(challengeDTO: $0) }
                .filter { $0.title.contains(keyword) }
    }

    func fetchSearchChallengesBy(categoryID: String) async -> [Challenge] {
        guard let list = try? await RoutinusDatabase.searchChallenges(categoryID: categoryID) else { return [] }
        return list.map { Challenge(challengeDTO: $0) }
    }

    func fetchLatestChallenges() async -> [Challenge] {
        guard let list = try? await RoutinusDatabase.newChallenges() else { return [] }
        return list.map { Challenge(challengeDTO: $0) }
    }

    func fetchChallenges(by userID: String) async -> [Challenge] {
        guard let list = try? await RoutinusDatabase.searchChallenges(ownerID: userID) else { return [] }
        return list.map { Challenge(challengeDTO: $0) }
    }
}
