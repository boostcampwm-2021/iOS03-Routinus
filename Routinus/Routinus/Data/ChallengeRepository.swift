//
//  ChallengeRepository.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/09.
//

import Foundation

import RoutinusNetwork
import RoutinusStorage

protocol ChallengeRepository {
    func fetchRecommendChallenges(completion: (([Challenge]) -> Void)?)
    func fetchSearchChallengesBy(keyword: String,
                                 completion: (([Challenge]) -> Void)?)
    func fetchSearchChallengesBy(categoryID: String,
                                 completion: (([Challenge]) -> Void)?)
    func fetchLatestChallenges(completion: (([Challenge]) -> Void)?)
    func fetchChallenges(by userID: String,
                         completion: (([Challenge]) -> Void)?)
    func fetchChallenges(of userID: String,
                         completion: (([Challenge]) -> Void)?)
    func fetchEdittingChallenge(challengeID: String,
                                completion: @escaping (Challenge) -> Void)
    func fetchChallenge(challengeID: String,
                        completion: @escaping (Challenge) -> Void)
    func save(challenge: Challenge,
              imageURL: String,
              thumbnailImageURL: String,
              authExampleImageURL: String,
              authExampleThumbnailImageURL: String)
    func update(challenge: Challenge,
                imageURL: String,
                thumbnailImageURL: String,
                authExampleImageURL: String,
                authExampleThumbnailImageURL: String)
    func updateParticipantCount(challengeID: String)
}

extension RoutinusRepository: ChallengeRepository {
    func fetchRecommendChallenges(completion: (([Challenge]) -> Void)?) {
        RoutinusNetwork.recommendChallenges { list in
            completion?(list.map { Challenge(challengeDTO: $0) })
        }
    }

    func fetchSearchChallengesBy(keyword: String,
                                 completion: (([Challenge]) -> Void)?) {
        RoutinusNetwork.latestChallenges { list in
            let challenges = list.map { Challenge(challengeDTO: $0) }
                .filter { $0.title.contains(keyword) }
            completion?(challenges)
        }
    }

    func fetchSearchChallengesBy(categoryID: String,
                                 completion: (([Challenge]) -> Void)?) {
        RoutinusNetwork.searchChallenges(categoryID: categoryID) { list in
            completion?(list.map { Challenge(challengeDTO: $0) })
        }
    }

    func fetchLatestChallenges(completion: (([Challenge]) -> Void)?) {
        RoutinusNetwork.newChallenges { list in
            completion?(list.map { Challenge(challengeDTO: $0) })
        }
    }

    func fetchChallenges(by userID: String,
                         completion: (([Challenge]) -> Void)?) {
        RoutinusNetwork.searchChallenges(ownerID: userID) { list in
            completion?(list.map { Challenge(challengeDTO: $0) })
        }
    }

    func fetchChallenges(of userID: String,
                         completion: (([Challenge]) -> Void)?) {
        RoutinusNetwork.searchChallenges(participantID: userID) { list in
            completion?(list.map { Challenge(challengeDTO: $0) })
        }
    }

    func fetchEdittingChallenge(challengeID: String,
                                completion: @escaping (Challenge) -> Void) {
        guard let ownerID = RoutinusRepository.userID() else { return }
        RoutinusNetwork.challenge(ownerID: ownerID,
                                   challengeID: challengeID) { dto in
            let imageURL = RoutinusStorage.cachedImageURL(from: challengeID, filename: "image")
            let thumbnailImageURL = RoutinusStorage.cachedImageURL(from: challengeID, filename: "thumbnail_image")
            let authExampleImageURL = RoutinusStorage.cachedImageURL(from: challengeID, filename: "auth")
            let authExampleThumbnailImageURL = RoutinusStorage.cachedImageURL(from: challengeID, filename: "thumbnail_auth")
            completion(Challenge(challengeDTO: dto,
                                 imageURL: imageURL,
                                 thumbnailImageURL: thumbnailImageURL,
                                 authExampleImageURL: authExampleImageURL,
                                 authExampleThumbnailImageURL: authExampleThumbnailImageURL))
        }
    }

    func fetchChallenge(challengeID: String,
                        completion: @escaping (Challenge) -> Void) {
        RoutinusNetwork.challenge(challengeID: challengeID) { dto in
            completion(Challenge(challengeDTO: dto))
        }
    }

    func save(challenge: Challenge,
              imageURL: String,
              thumbnailImageURL: String,
              authExampleImageURL: String,
              authExampleThumbnailImageURL: String) {
        guard let startDate = challenge.startDate?.toDateString(),
              let endDate = challenge.endDate?.toDateString() else { return }
        let challengeDTO = ChallengeDTO(id: challenge.challengeID,
                                        title: challenge.title,
                                        authMethod: challenge.authMethod,
                                        categoryID: challenge.category.id,
                                        week: challenge.week,
                                        desc: challenge.introduction,
                                        startDate: startDate,
                                        endDate: endDate,
                                        participantCount: 1,
                                        ownerID: challenge.ownerID)

        let participationDTO = ParticipationDTO(authCount: 0,
                                                challengeID: challenge.challengeID,
                                                joinDate: startDate,
                                                userID: challenge.ownerID)

        RoutinusNetwork.insertChallenge(challenge: challengeDTO,
                                        participation: participationDTO,
                                        imageURL: imageURL,
                                        thumbnailImageURL: thumbnailImageURL,
                                        authExampleImageURL: authExampleImageURL,
                                        authExampleThumbnailImageURL: authExampleThumbnailImageURL) {
            RoutinusStorage.removeCachedImages(from: "temp")
        }
    }

    func update(challenge: Challenge,
                imageURL: String,
                thumbnailImageURL: String,
                authExampleImageURL: String,
                authExampleThumbnailImageURL: String) {
        guard let startDate = challenge.startDate?.toDateString(),
              let endDate = challenge.endDate?.toDateString() else { return }
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

        RoutinusNetwork.patchChallenge(challengeDTO: challengeDTO,
                                       imageURL: imageURL,
                                       thumbnailImageURL: thumbnailImageURL,
                                       authExampleImageURL: authExampleImageURL,
                                       authExampleThumbnailImageURL: authExampleThumbnailImageURL) {
            RoutinusStorage.removeCachedImages(from: challenge.challengeID)
        }
    }

    func updateParticipantCount(challengeID: String) {
        RoutinusNetwork.updateParticipantCount(challengeID: challengeID, completion: nil)
    }
}
