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

    func update(challenge: Challenge) {
        repository.update(challenge: challenge)
    }
}
