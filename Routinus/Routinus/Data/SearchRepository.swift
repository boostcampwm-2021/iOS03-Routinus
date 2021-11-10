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
    func fetchNewChallenges() async -> [Challenge]
}

extension RoutinusRepository: SearchRepository {
    func fetchSearchChallengesBy(keyword: String) async -> [Challenge] {
        guard let list = try? await RoutinusDatabase.searchChallengesBy(keyword: keyword) else { return [] }
        return list.map { Challenge(challengeDTO: $0) }
    }
    
    func fetchSearchChallengesBy(categoryID: String) async -> [Challenge] {
        guard let list = try? await RoutinusDatabase.searchChallengesBy(categoryID: categoryID) else { return [] }
        return list.map { Challenge(challengeDTO: $0) }
    }

    func fetchNewChallenges() async -> [Challenge] {
        guard let list = try? await RoutinusDatabase.newChallenge() else { return [] }
        return list.map { Challenge(challengeDTO: $0) }
    }
}
