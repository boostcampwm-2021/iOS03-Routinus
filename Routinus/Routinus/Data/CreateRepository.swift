//
//  CreateRepository.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/09.
//

import Foundation

import RoutinusDatabase

protocol CreateRepository {
    func userID() -> String?
    func save(challenge: ChallengeDTO, imageURL: String, authImageURL: String)
}

extension RoutinusRepository: CreateRepository {
    func save(challenge: ChallengeDTO, imageURL: String, authImageURL: String) {
        Task {
            try await RoutinusDatabase.createChallenge(challenge: challenge,
                                                       imageURL: imageURL,
                                                       authImageURL: authImageURL)
        }
    }
}
