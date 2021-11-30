//
//  ParticipationFetchableUsecaseNilMock.swift
//  RoutinusTests
//
//  Created by 박상우 on 2021/12/01.
//

import XCTest
@testable import Routinus

class ParticipationFetchableUsecaseNilMock: ParticipationFetchableUsecase {
    func fetchParticipation(challengeID: String, completion: @escaping (Participation?) -> Void) {
        completion(nil)
    }
}
