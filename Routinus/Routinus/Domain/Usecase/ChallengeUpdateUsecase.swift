//
//  ChallengeUpdateUsecase.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/13.
//

import Foundation

import RoutinusDatabase

protocol ChallengeUpdatableUsecase {
    func fetchChallenge(challengeID: String, completion: @escaping (Challenge?) -> Void)
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

    func fetchChallenge(challengeID: String, completion: @escaping (Challenge?) -> Void) {
        Task {
            guard let challenge = await repository.fetchChallenge(challengeId: challengeID) else {
                completion(nil)
                return
            }
            completion(challenge)
        }
    }

    func updateChallenge(challenge: Challenge) {
        repository.update(challenge: challenge)
    }
}
