//
//  ChallengeUpdateUsecase.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/13.
//

import Foundation

protocol ChallengeUpdatableUsecase {
    func endDate(startDate: Date, week: Int) -> Date?
    func update(challenge: Challenge)
    func updateParticipantCount(challengeID: String)
}

struct ChallengeUpdateUsecase: ChallengeUpdatableUsecase {
    static let didUpdateChallenge = Notification.Name("didUpdateChallenge")

    var repository: ChallengeRepository

    init(repository: ChallengeRepository) {
        self.repository = repository
    }

    func endDate(startDate: Date, week: Int) -> Date? {
        let calendar = Calendar.current
        let day = DateComponents(day: week * 7)
        guard let endDate = calendar.date(byAdding: day, to: startDate) else { return nil }
        return endDate
    }

    func update(challenge: Challenge) {
        repository.update(challenge: challenge) {
            NotificationCenter.default.post(name: ChallengeUpdateUsecase.didUpdateChallenge,
                                            object: nil)
        }
    }

    func updateParticipantCount(challengeID: String) {
        repository.updateParticipantCount(challengeID: challengeID) {
            NotificationCenter.default.post(name: ChallengeUpdateUsecase.didUpdateChallenge,
                                            object: nil)
        }
    }
}
