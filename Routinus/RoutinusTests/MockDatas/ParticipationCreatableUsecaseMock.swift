//
//  ParticipationCreatableUsecaseMock.swift
//  RoutinusTests
//
//  Created by 박상우 on 2021/11/30.
//

import XCTest
@testable import Routinus

class ParticipationCreatableUsecaseMock: ParticipationCreatableUsecase {
    func createParticipation(challengeID: String) {
        print("create Participation")
    }
}
