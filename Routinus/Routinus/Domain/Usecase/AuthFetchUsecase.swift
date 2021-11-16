//
//  AuthFetchUsecase.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/17.
//

import Foundation

protocol AuthFetchableUsecase {
    func fetchChallenge(challengeID: String, completion: @escaping (Challenge?) -> Void)
}

struct AuthFetchUsecase: AuthFetchableUsecase {
    var repository: AuthRepository

    init(repository: AuthRepository) {
        self.repository = repository
    }

    func fetchChallenge(challengeID: String, completion: @escaping (Challenge?) -> Void) {
        Task {
            let challenge = await repository.fetchAuthChallenge(challengeID: challengeID)
            completion(challenge)
        }
    }
}
