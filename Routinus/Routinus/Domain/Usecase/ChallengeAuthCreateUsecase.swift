//
//  ChallengeAuthCreateUsecase.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/17.
//

import Foundation

protocol ChallengeAuthCreatableUsecase {
    func createChallengeAuth(challengeID: String,
                             userAuthImageURL: String,
                             userAuthThumbnailImageURL: String)
}

struct ChallengeAuthCreateUsecase: ChallengeAuthCreatableUsecase {
    var repository: ChallengeAuthRepository

    init(repository: ChallengeAuthRepository) {
        self.repository = repository
    }

    func createChallengeAuth(challengeID: String,
                             userAuthImageURL: String,
                             userAuthThumbnailImageURL: String) {
        guard let userID = RoutinusRepository.userID() else { return }

        let challengeAuth = ChallengeAuth(challengeID: challengeID,
                                          userID: userID,
                                          date: Date.now,
                                          time: Date.now)

        repository.save(challengeAuth: challengeAuth,
                        userAuthImageURL: userAuthImageURL,
                        userAuthThumbnailImageURL: userAuthThumbnailImageURL)
    }
    
    
}
