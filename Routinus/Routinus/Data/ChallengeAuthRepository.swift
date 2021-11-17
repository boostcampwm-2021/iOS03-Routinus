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
}

extension RoutinusRepository: ChallengeAuthRepository {
    func save(challengeAuth: ChallengeAuth,
              userAuthImageURL: String,
              userAuthThumbnailImageURL: String) {
        guard let date = challengeAuth.date?.toString(),
              let time = challengeAuth.time?.toStringHourMinute() else { return }

        let challengeAuthDTO = ChallengeAuthDTO(challengeID: challengeAuth.challengeID,
                                                userID: challengeAuth.userID,
                                                date: date,
                                                time: time)
        
        RoutinusDatabase.createChallengeAuth(challengeAuth: challengeAuthDTO,
                                             userAuthImageURL: userAuthImageURL,
                                             userAuthThumbnailImageURL: userAuthThumbnailImageURL) {
            RoutinusImageManager.removeTempCachedImages()
        }
    }
}
