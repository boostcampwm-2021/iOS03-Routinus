//
//  UpdateRepository.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/13.
//

import Foundation

import RoutinusDatabase
import RoutinusImageManager

protocol UpdateRepository {
    func fetchChallenge(challengeID: String,
                        completion: @escaping (Challenge) -> Void)
    func update(challenge: Challenge,
                imageURL: String,
                thumbnailImageURL: String,
                authExampleImageURL: String,
                authExampleThumbnailImageURL: String) async
}

extension RoutinusRepository: UpdateRepository {
    func fetchChallenge(challengeID: String,
                        completion: @escaping (Challenge) -> Void) {
        guard let ownerID = RoutinusRepository.userID() else { return }
        RoutinusDatabase.challenge(ownerID: ownerID,
                                   challengeID: challengeID) { dto in
            completion(Challenge(challengeDTO: dto))
        }
    }

    func update(challenge: Challenge,
                imageURL: String,
                thumbnailImageURL: String,
                authExampleImageURL: String,
                authExampleThumbnailImageURL: String) async {
        guard let startDate = challenge.startDate?.toString(), let endDate = challenge.endDate?.toString() else { return }
        let challengeDTO = ChallengeDTO(id: challenge.challengeID,
                                        title: challenge.title,
                                        authMethod: challenge.authMethod,
                                        categoryID: challenge.category.id,
                                        week: challenge.week,
                                        desc: challenge.introduction,
                                        startDate: startDate,
                                        endDate: endDate,
                                        participantCount: challenge.participantCount,
                                        ownerID: challenge.ownerID)
        RoutinusDatabase.patchChallenge(challengeDTO: challengeDTO,
                                        imageURL: imageURL,
                                        thumbnailImageURL: thumbnailImageURL,
                                        authExampleImageURL: authExampleImageURL,
                                        authExampleThumbnailImageURL: authExampleThumbnailImageURL) {
            RoutinusImageManager.removeTempCachedImages()
        }
    }
}
