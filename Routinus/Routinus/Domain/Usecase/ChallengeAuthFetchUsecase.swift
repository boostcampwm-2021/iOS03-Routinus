//
//  ChallengeAuthFetchUsecase.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/18.
//

import Foundation

protocol ChallengeAuthFetchableUsecase {
    func fetchChallengeAuth(challengeID: String,
                            completion: @escaping (ChallengeAuth?) -> Void)
    func fetchChallengeAuths(challengeID: String,
                             completion: @escaping ([ChallengeAuth]) -> Void)
}

struct ChallengeAuthFetchUsecase: ChallengeAuthFetchableUsecase {
    var repository: ChallengeAuthRepository

    init(repository: ChallengeAuthRepository) {
        self.repository = repository
    }

    func fetchChallengeAuth(challengeID: String,
                            completion: @escaping (ChallengeAuth?) -> Void) {
        guard let userID = RoutinusRepository.userID() else { return }
        repository.fetchChallengeAuth(todayDate: Date().toDateString(),
                                      userID: userID,
                                      challengeID: challengeID) { challengeAuth in
            completion(challengeAuth)
        }
    }

    func fetchChallengeAuths(challengeID: String,
                             completion: @escaping ([ChallengeAuth]) -> Void) {
        repository.fetchChallengeAuths(challengeID: challengeID) { challengeAuths in
            completion(challengeAuths)
        }
    }
}
