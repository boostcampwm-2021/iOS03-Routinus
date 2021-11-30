//
//  ParticipantionFetchableUsecaseMock.swift
//  RoutinusTests
//
//  Created by 박상우 on 2021/11/30.
//

import XCTest
@testable import Routinus

class ParticipantionFetchableUsecaseMock: ParticipationFetchableUsecase {
    func fetchParticipation(challengeID: String, completion: @escaping (Participation?) -> Void) {
        let participationDTO = ParticipationDTO(authCount: 2,
                                                challengeID: "testChallengeID",
                                                joinDate: "20211124",
                                                userID: "testUserID")
        let participation = Participation(participationDTO: participationDTO)
        completion(participation)
    }
}
