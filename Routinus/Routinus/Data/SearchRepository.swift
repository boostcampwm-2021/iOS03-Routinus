//
//  SearchRepository.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/09.
//

import Foundation

import RoutinusDatabase

protocol SearchRepository {
    func fetchSearchChallengesBy(keyword: String) async -> [Challenge]
    func fetchSearchChallengesBy(categoryID: String) async -> [Challenge]
    func fetchLatestChallenges() async -> [Challenge]
}

extension RoutinusRepository: SearchRepository {
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
}
