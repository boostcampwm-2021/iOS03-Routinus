//
//  HomeFetchableUsecaseMock.swift
//  RoutinusTests
//
//  Created by 박상우 on 2021/11/08.
//

import XCTest
@testable import Routinus

class HomeFetchableUsecaseMock: HomeFetchableUsecase {
    init() {}

    func fetchUser(completion: @escaping (User) -> Void) {
        let user = User(id: "testID",
                        name: "testName",
                        continuityDay: 2,
                        userImageCategoryID: "1",
                        grade: 2)
        completion(user)
    }

    func fetchTodayRoutines(completion: @escaping ([TodayRoutine]) -> Void) {
        let todayRoutine = [TodayRoutine(challengeID: "mockChallengeID",
                                         category: .exercise,
                                         title: "30분 운동하기",
                                         authCount: 2,
                                         totalCount: 4)]
        completion(todayRoutine)
    }

    func fetchAcheivements(yearMonth: String, completion: @escaping ([Achievement]) -> Void) {
        let achievement = [Achievement(yearMonth: "202111",
                                       day: "06",
                                       achievementCount: 1,
                                       totalCount: 2)]
        completion(achievement)
    }
}
