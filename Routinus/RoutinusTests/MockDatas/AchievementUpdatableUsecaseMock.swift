//
//  AchievementUpdatableUsecaseMock.swift
//  RoutinusTests
//
//  Created by 박상우 on 2021/11/30.
//

import XCTest
@testable import Routinus

class AchievementUpdatableUsecaseMock: AchievementUpdatableUsecase {
    func updateAchievementCount() {
        print("update AchievementCount")
    }

    func updateTotalCount() {
        print("update TotalCount")
    }
}
