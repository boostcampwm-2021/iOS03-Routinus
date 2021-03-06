//
//  ImageUpdateUsecase.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/23.
//

import Foundation

protocol ImageUpdatableUsecase {
    func updateImage(challenge: Challenge, isChangedImage: Bool, isChangedAuthImage: Bool)
}

struct ImageUpdateUsecase: ImageUpdatableUsecase {
    static let didUpdateChallengeImage = Notification.Name("didUpdateChallengeImage")

    var repository: ImageRepository

    init(repository: ImageRepository) {
        self.repository = repository
    }

    func updateImage(challenge: Challenge, isChangedImage: Bool, isChangedAuthImage: Bool) {
        if isChangedImage {
            repository.updateImage(challengeID: challenge.challengeID,
                                   imageURL: challenge.imageURL,
                                   thumbnailImageURL: challenge.thumbnailImageURL) {
                NotificationCenter.default.post(name: ImageUpdateUsecase.didUpdateChallengeImage,
                                                object: nil)
            }
        }
        if isChangedAuthImage {
            repository.updateImage(
                challengeID: challenge.challengeID,
                authExampleImageURL: challenge.authExampleImageURL,
                authExampleThumbnailImageURL: challenge.authExampleThumbnailImageURL
            ) {
                NotificationCenter.default.post(name: ImageUpdateUsecase.didUpdateChallengeImage,
                                                object: nil)
            }
        }
    }
}
