//
//  ChallengeUpdateUsecase.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/13.
//

import Foundation

protocol ChallengeUpdatableUsecase {
    func updateChallenge(challenge: Challenge)
    func endDate(startDate: Date, week: Int) -> Date?
}

struct ChallengeUpdateUsecase: ChallengeUpdatableUsecase {
    var repository: ChallengeRepository

    init(repository: ChallengeRepository) {
        self.repository = repository
    }

    func endDate(startDate: Date, week: Int) -> Date? {
        let calendar = Calendar.current
        let day = DateComponents(day: week*7)
        guard let endDate = calendar.date(byAdding: day, to: startDate) else { return nil }
        return endDate
    }

    func updateChallenge(challenge: Challenge) {
        // TODO: Task있었는데 completion 필요 없는 것 같아서 지웠습니다 확인 바람!
        repository.update(challenge: challenge,
                          imageURL: challenge.imageURL,
                          thumbnailImageURL: challenge.thumbnailImageURL,
                          authExampleImageURL: challenge.authExampleImageURL,
                          authExampleThumbnailImageURL: challenge.authExampleThumbnailImageURL)
    }
}
