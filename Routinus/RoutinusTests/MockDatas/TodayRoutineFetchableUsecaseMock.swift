//
//  TodayRoutineFetchableUsecaseMock.swift
//  RoutinusTests
//
//  Created by 박상우 on 2021/11/30.
//

import XCTest
@testable import Routinus

class TodayRoutineFetchableUsecaseMock: TodayRoutineFetchableUsecase {
    func fetchTodayRoutines(completion: @escaping ([TodayRoutine]) -> Void) {
        let todayRoutines: [TodayRoutine] = [TodayRoutine(challengeID: "testChallenge1",
                                                          category: .exercise,
                                                          title: "테스트 챌린지1",
                                                          authCount: 0,
                                                          totalCount: 7),
                                             TodayRoutine(challengeID: "testChallenge2",
                                                          category: .etc,
                                                          title: "테스트 챌린지2",
                                                          authCount: 1,
                                                          totalCount: 14)]
        completion(todayRoutines)
    }
}
