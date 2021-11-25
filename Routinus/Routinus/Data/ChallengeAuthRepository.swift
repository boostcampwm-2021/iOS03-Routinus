//
//  ChallengeAuthRepository.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/17.
//

import Foundation

import RoutinusNetwork
import RoutinusStorage

protocol ChallengeAuthRepository {
    func insert(challengeAuth: ChallengeAuth,
                userAuthImageURL: String,
                userAuthThumbnailImageURL: String,
                completion: (() -> Void)?)
    func fetchChallengeAuth(todayDate: String,
                            userID: String,
                            challengeID: String,
                            completion: @escaping (ChallengeAuth?) -> Void)
    func fetchChallengeAuths(challengeID: String,
                             completion: (([ChallengeAuth]) -> Void)?)
    func fetchMyChallengeAuths(userID: String,
                               challengeID: String,
                               completion: (([ChallengeAuth]) -> Void)?)
}

extension RoutinusRepository: ChallengeAuthRepository {
    func insert(challengeAuth: ChallengeAuth,
                userAuthImageURL: String,
                userAuthThumbnailImageURL: String,
                completion: (() -> Void)?) {
        guard let date = challengeAuth.date?.toDateString(),
              let time = challengeAuth.time?.toTimeString() else { return }

        let challengeAuthDTO = ChallengeAuthDTO(challengeID: challengeAuth.challengeID,
                                                userID: challengeAuth.userID,
                                                date: date,
                                                time: time)

        RoutinusNetwork.insertChallengeAuth(challengeAuth: challengeAuthDTO,
                                            userAuthImageURL: userAuthImageURL,
                                            userAuthThumbnailImageURL: userAuthThumbnailImageURL) {
            RoutinusStorage.removeCachedImages(from: "temp")
            completion?()
        }
    }

    func fetchChallengeAuth(todayDate: String,
                            userID: String,
                            challengeID: String,
                            completion: @escaping (ChallengeAuth?) -> Void) {
        RoutinusNetwork.challengeAuth(todayDate: todayDate,
                                      userID: userID,
                                      challengeID: challengeID) { dto in
            guard let dto = dto,
                  dto.document != nil else {
                completion(nil)
                return
            }
            completion(ChallengeAuth(challengeAuthDTO: dto))
        }
    }

    func fetchChallengeAuths(challengeID: String,
                             completion: (([ChallengeAuth]) -> Void)?) {
        RoutinusNetwork.challengeAuths(challengeID: challengeID) { challengeAuths in
            let challengeAuths = challengeAuths
                                    .filter { $0.document != nil }
                                    .map { ChallengeAuth(challengeAuthDTO: $0) }
            completion?(challengeAuths)
        }
    }

    func fetchMyChallengeAuths(userID: String,
                               challengeID: String,
                               completion: (([ChallengeAuth]) -> Void)?) {
        RoutinusNetwork.challengeAuths(userID: userID,
                                       challengeID: challengeID) { challengeAuths in
            let challengeAuths = challengeAuths
                                    .filter { $0.document != nil }
                                    .map { ChallengeAuth(challengeAuthDTO: $0) }
            completion?(challengeAuths)
        }
    }
}
