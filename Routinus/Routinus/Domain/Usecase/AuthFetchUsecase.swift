//
//  AuthFetchUsecase.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/18.
//

import Foundation

protocol AuthFetchableUsecase {
    func fetchAuth(challengeID: String, completion: @escaping (Auth?) -> Void)
    func fetchAuths(challengeID: String, completion: @escaping ([Auth]) -> Void)
    func fetchMyAuths(challengeID: String, completion: @escaping ([Auth]) -> Void)
    func fetchAuthedChallenges(date: Date, completion: @escaping ([Challenge]) -> Void)
}

struct AuthFetchUsecase: AuthFetchableUsecase {
    var repository: AuthRepository

    init(repository: AuthRepository) {
        self.repository = repository
    }

    func fetchAuth(challengeID: String, completion: @escaping (Auth?) -> Void) {
        guard let userID = RoutinusRepository.userID() else { return }
        repository.fetchAuth(todayDate: Date().toDateString(),
                             userID: userID,
                             challengeID: challengeID) { auth in
            completion(auth)
        }
    }

    func fetchAuths(challengeID: String, completion: @escaping ([Auth]) -> Void) {
        repository.fetchAuths(challengeID: challengeID) { auths in
            completion(auths)
        }
    }

    func fetchMyAuths(challengeID: String, completion: @escaping ([Auth]) -> Void) {
        guard let userID = RoutinusRepository.userID() else { return }
        repository.fetchMyAuths(userID: userID, challengeID: challengeID) { auths in
            completion(auths)
        }
    }

    func fetchAuthedChallenges(date: Date, completion: @escaping ([Challenge]) -> Void) {
        guard let userID = RoutinusRepository.userID() else { return }
        repository.fetchMyAuthedChallenges(date: date.toDateString(), userID: userID) { challenges in
            completion(challenges)
        }
    }
}
