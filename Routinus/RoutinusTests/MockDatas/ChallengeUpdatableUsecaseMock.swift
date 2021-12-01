//
//  ChallengeUpdatableUsecaseMock.swift
//  RoutinusTests
//
//  Created by 박상우 on 2021/11/30.
//

import XCTest
@testable import Routinus

class ChallengeUpdatableUsecaseMock: ChallengeUpdatableUsecase {
    func endDate(startDate: Date, week: Int) -> Date? {
        let calendar = Calendar.current
        let day = DateComponents(day: week * 7)
        guard let endDate = calendar.date(byAdding: day, to: startDate) else { return nil }
        return endDate
    }
    
    func update(challenge: Challenge) {
        print("update Challenge")
    }
    
    func updateParticipantCount(challengeID: String) {
        print("update ParticipantCount")
    }
}
