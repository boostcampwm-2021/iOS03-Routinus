//
//  AuthRepository.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/17.
//

import Foundation

protocol AuthRepository {
    func insert(auth: Auth,
                userAuthImageURL: String,
                userAuthThumbnailImageURL: String,
                completion: (() -> Void)?)
    func fetchAuth(todayDate: String,
                   userID: String,
                   challengeID: String,
                   completion: @escaping (Auth?) -> Void)
    func fetchAuths(challengeID: String, completion: (([Auth]) -> Void)?)
    func fetchMyAuths(userID: String, challengeID: String, completion: (([Auth]) -> Void)?)
    func fetchMyAuthedChallengesOfDate(date: String, userID: String, completion: (([Challenge]) -> Void)?)
}

extension RoutinusRepository: AuthRepository {
    func insert(auth: Auth,
                userAuthImageURL: String,
                userAuthThumbnailImageURL: String,
                completion: (() -> Void)?) {
        guard let date = auth.date?.toDateString(),
              let time = auth.time?.toTimeString() else { return }

        let authDTO = AuthDTO(challengeID: auth.challengeID,
                              userID: auth.userID,
                              date: date,
                              time: time)

        FirebaseService.insertAuth(auth: authDTO,
                                   userAuthImageURL: userAuthImageURL,
                                   userAuthThumbnailImageURL: userAuthThumbnailImageURL) {
            ImageManager.removeCachedImages(from: "temp")
            completion?()
        }
    }

    func fetchAuth(todayDate: String,
                   userID: String,
                   challengeID: String,
                   completion: @escaping (Auth?) -> Void) {
        FirebaseService.auth(todayDate: todayDate,
                             userID: userID,
                             challengeID: challengeID) { dto in
            guard let dto = dto,
                  dto.document != nil else {
                completion(nil)
                return
            }
            completion(Auth(authDTO: dto))
        }
    }

    func fetchAuths(challengeID: String, completion: (([Auth]) -> Void)?) {
        FirebaseService.auths(challengeID: challengeID) { auths in
            let auths = auths
                .filter { $0.document != nil }
                .map { Auth(authDTO: $0) }
            completion?(auths)
        }
    }

    func fetchMyAuths(userID: String, challengeID: String, completion: (([Auth]) -> Void)?) {
        FirebaseService.auths(userID: userID, challengeID: challengeID) { auths in
            let auths = auths
                .filter { $0.document != nil }
                .map { Auth(authDTO: $0) }
            completion?(auths)
        }
    }

    func fetchMyAuthedChallengesOfDate(date: String, userID: String, completion: (([Challenge]) -> Void)?) {
        FirebaseService.authedChallengesOfDate(date: date, userID: userID) { challenges in
            let challenges = challenges
                .filter { $0.document != nil }
                .map { Challenge(challengeDTO: $0) }
            completion?(challenges)
        }
    }
}
