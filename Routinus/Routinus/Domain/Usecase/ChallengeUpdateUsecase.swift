//
//  ChallengeUpdateUsecase.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/13.
//

import Foundation

import RoutinusDatabase

protocol ChallengeUpdatableUsecase {
    func fetchChallenge(ownerID: String, challengeID: String, completion: @escaping (Challenge?) -> Void)
    func updateChallenge(challenge: Challenge)
}

struct ChallengeUpdateUsecase: ChallengeUpdatableUsecase {

    var repository: UpdateRepository

    init(repository: UpdateRepository) {
        self.repository = repository
    }

    func fetchChallenge(ownerID: String, challengeID: String, completion: @escaping (Challenge?) -> Void) {
        Task {
            guard let challenge = await repository.fetchChallenge(ownerId: ownerID, challengeId: challengeID) else {
                completion(nil)
                return
            }
            completion(challenge)
        }
    }

    func updateChallenge(challenge: Challenge) {
        repository.update(challenge: challenge)
    }
}
