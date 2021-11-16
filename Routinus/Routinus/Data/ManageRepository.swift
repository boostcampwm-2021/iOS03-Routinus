//
//  ManageRepository.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/12.
//

import Foundation

import RoutinusDatabase

protocol ManageRepository {
    func fetchChallenges(by userID: String) async -> [Challenge]
}

extension RoutinusRepository: ManageRepository {
    func fetchChallenges(by userID: String) async -> [Challenge] {
        guard let list = try? await RoutinusDatabase.searchChallenges(ownerID: userID) else { return [] }
        return list.map { Challenge(challengeDTO: $0) }
    }
}
