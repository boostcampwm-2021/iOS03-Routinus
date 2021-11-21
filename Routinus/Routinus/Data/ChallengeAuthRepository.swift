//
//  ChallengeAuthRepository.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/17.
//

import Foundation

import RoutinusDatabase
import RoutinusImageManager

protocol ChallengeAuthRepository {
    func save(challengeAuth: ChallengeAuth,
              userAuthImageURL: String,
              userAuthThumbnailImageURL: String)
    func fetchChallengeAuth(todayDate: String,
                            userID: String,
                            challengeID: String,
                            completion: @escaping (ChallengeAuth?) -> Void)
}

extension RoutinusRepository: ChallengeAuthRepository {
    func save(challengeAuth: ChallengeAuth,
              userAuthImageURL: String,
              userAuthThumbnailImageURL: String) {
        guard let date = challengeAuth.date?.toDateString(),
              let time = challengeAuth.time?.toTimeString() else { return }

        let challengeAuthDTO = ChallengeAuthDTO(challengeID: challengeAuth.challengeID,
                                                userID: challengeAuth.userID,
                                                date: date,
                                                time: time)

        RoutinusDatabase.insertChallengeAuth(challengeAuth: challengeAuthDTO,
                                             userAuthImageURL: userAuthImageURL,
                                             userAuthThumbnailImageURL: userAuthThumbnailImageURL) {
            RoutinusImageManager.removeCachedImages(from: "temp")
        }
    }

    func fetchChallengeAuth(todayDate: String,
                            userID: String,
                            challengeID: String,
                            completion: @escaping (ChallengeAuth?) -> Void) {
        RoutinusDatabase.challengeAuth(todayDate: todayDate,
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

}
