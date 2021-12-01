//
//  AchievementFetchableUsecaseMock.swift
//  RoutinusTests
//
//  Created by 박상우 on 2021/11/30.
//

import XCTest
@testable import Routinus

class AchievementFetchableUsecaseMock: AchievementFetchableUsecase {
    func fetchAchievements(yearMonth: String, completion: @escaping ([Achievement]) -> Void) {
        let achievements: [Achievement] = [Achievement(yearMonth: "202111",
                                                       day: "29",
                                                       achievementCount: 2,
                                                       totalCount: 4),
                                           Achievement(yearMonth: "202111",
                                                       day: "30",
                                                       achievementCount: 4,
                                                       totalCount: 5)]
        completion(achievements)
    }
}
