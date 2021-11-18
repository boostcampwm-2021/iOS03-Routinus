//
//  ChallengeRepository.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/09.
//

import Foundation

import RoutinusDatabase
import RoutinusImageManager

protocol ChallengeRepository {
    func fetchRecommendChallenges() async -> [Challenge]
    func fetchSearchChallengesBy(keyword: String) async -> [Challenge]
    func fetchSearchChallengesBy(categoryID: String) async -> [Challenge]
    func fetchLatestChallenges() async -> [Challenge]
    func fetchChallenges(by userID: String) async -> [Challenge]
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
                authExampleThumbnailImageURL: String) async
}

extension RoutinusRepository: ChallengeRepository {
    func fetchRecommendChallenges() async -> [Challenge] {
        guard let list = try? await RoutinusDatabase.recommendChallenges() else { return [] }
        return list.map { Challenge(challengeDTO: $0) }
    }

    func fetchSearchChallengesBy(keyword: String) async -> [Challenge] {
        guard let list = try? await RoutinusDatabase.latestChallenges() else { return [] }
        return list.map { Challenge(challengeDTO: $0) }
                .filter { $0.title.contains(keyword) }
    }

    func fetchSearchChallengesBy(categoryID: String) async -> [Challenge] {
        guard let list = try? await RoutinusDatabase.searchChallenges(categoryID: categoryID) else { return [] }
        return list.map { Challenge(challengeDTO: $0) }
    }

    func fetchLatestChallenges() async -> [Challenge] {
        guard let list = try? await RoutinusDatabase.newChallenges() else { return [] }
        return list.map { Challenge(challengeDTO: $0) }
    }

    func fetchChallenges(by userID: String) async -> [Challenge] {
        guard let list = try? await RoutinusDatabase.searchChallenges(ownerID: userID) else { return [] }
        return list.map { Challenge(challengeDTO: $0) }
    }

    func fetchEdittingChallenge(challengeID: String,
                        completion: @escaping (Challenge) -> Void) {
        guard let ownerID = RoutinusRepository.userID() else { return }
        RoutinusDatabase.challenge(ownerID: ownerID,
                                   challengeID: challengeID) { dto in
            completion(Challenge(challengeDTO: dto))
        }
    }

    func fetchChallenge(challengeID: String,
                        completion: @escaping (Challenge) -> Void) {
        RoutinusDatabase.challenge(challengeID: challengeID) { dto in
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

        RoutinusDatabase.createChallenge(challenge: challengeDTO,
                                         imageURL: imageURL,
                                         thumbnailImageURL: thumbnailImageURL,
                                         authExampleImageURL: authExampleImageURL,
                                         authExampleThumbnailImageURL: authExampleThumbnailImageURL) {
            RoutinusImageManager.removeTempCachedImages()
        }
    }

    func update(challenge: Challenge,
                imageURL: String,
                thumbnailImageURL: String,
                authExampleImageURL: String,
                authExampleThumbnailImageURL: String) async {
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
        RoutinusDatabase.patchChallenge(challengeDTO: challengeDTO,
                                        imageURL: imageURL,
                                        thumbnailImageURL: thumbnailImageURL,
                                        authExampleImageURL: authExampleImageURL,
                                        authExampleThumbnailImageURL: authExampleThumbnailImageURL) {
            RoutinusImageManager.removeTempCachedImages()
        }
    }
}
