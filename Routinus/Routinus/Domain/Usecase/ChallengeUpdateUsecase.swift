//
//  ChallengeUpdateUsecase.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/13.
//

import Foundation

protocol ChallengeUpdatableUsecase {
//    func fetchChallenge(challengeID: String, completion: @escaping (Challenge?) -> Void)
    func updateChallenge(challenge: Challenge)
    func endDate(startDate: Date, week: Int) -> Date?
}

struct ChallengeUpdateUsecase: ChallengeUpdatableUsecase {
    var repository: UpdateRepository

    init(repository: UpdateRepository) {
        self.repository = repository
    }

    func endDate(startDate: Date, week: Int) -> Date? {
        let calendar = Calendar.current
        let day = DateComponents(day: week*7)
        guard let endDate = calendar.date(byAdding: day, to: startDate) else { return nil }
        return endDate
    }

//    func fetchChallenge(challengeID: String, completion: @escaping (Challenge?) -> Void) {
//        repository.fetchChallenge(challengeID: challengeID) { challenge in
//            completion(challenge)
//        }
//    }

    func updateChallenge(challenge: Challenge) {
        Task {
            await repository.update(challenge: challenge,
                                    imageURL: challenge.imageURL,
                                    thumbnailImageURL: challenge.thumbnailImageURL,
                                    authExampleImageURL: challenge.authExampleImageURL,
                                    authExampleThumbnailImageURL: challenge.authExampleThumbnailImageURL)
        }
    }
}
