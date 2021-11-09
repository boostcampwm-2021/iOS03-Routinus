//
//  CreateRepository.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/09.
//

import Foundation

import RoutinusDatabase

protocol CreateRepository {
    func save(challenge: ChallengeDTO)
}

extension RoutinusRepository: CreateRepository {
    func save(challenge: ChallengeDTO) {
        Task {
            try await RoutinusDatabase.createChallenge(challenge: challenge)
        }
    }
}
