//
//  SearchRepository.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/09.
//

import Foundation

import RoutinusDatabase

protocol SearchRepository {
    func fetchChallenges() async -> [Challenge]
}

extension RoutinusRepository: SearchRepository {
    func fetchChallenges() async -> [Challenge] {
        guard let list = try? await RoutinusDatabase.challengeInfo() else { return [] }
        return list.map { Challenge(challengeDTO: $0) }
    }
}
