//
//  AuthCreateUsecase.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/17.
//

import Foundation

protocol AuthCreatableUsecase {
    func createAuth(challengeID: String,
                    userAuthImageURL: String,
                    userAuthThumbnailImageURL: String)
}

struct AuthCreateUsecase: AuthCreatableUsecase {
    static let didCreateAuth = Notification.Name("didCreateAuth")

    var repository: AuthRepository

    init(repository: AuthRepository) {
        self.repository = repository
    }

    func createAuth(challengeID: String,
                    userAuthImageURL: String,
                    userAuthThumbnailImageURL: String) {
        guard let userID = RoutinusRepository.userID() else { return }
        let auth = Auth(challengeID: challengeID, userID: userID, date: Date(), time: Date())

        repository.insert(auth: auth,
                          userAuthImageURL: userAuthImageURL,
                          userAuthThumbnailImageURL: userAuthThumbnailImageURL) {
            NotificationCenter.default.post(name: AuthCreateUsecase.didCreateAuth,
                                            object: nil)
        }
    }
}
