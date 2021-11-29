//
//  AchievementUpdateUsecase.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/18.
//

import Foundation

protocol AchievementUpdatableUsecase {
    func updateAchievementCount()
    func updateTotalCount()
}

struct AchievementUpdateUsecase: AchievementUpdatableUsecase {
    static let didUpdateAchievement = Notification.Name("didUpdateAchievement")

    var repository: AchievementRepository

    init(repository: AchievementRepository) {
        self.repository = repository
    }

    func updateAchievementCount() {
        guard let userID = RoutinusRepository.userID() else { return }
        let yearMonth = Date().toYearMonthString()
        let day = Date().toDayString()
        self.repository.updateAchievementCount(userID: userID, yearMonth: yearMonth, day: day) {
            NotificationCenter.default.post(name: AchievementUpdateUsecase.didUpdateAchievement,
                                            object: nil)
        }
    }

    func updateTotalCount() {
        guard let userID = RoutinusRepository.userID() else { return }
        let yearMonth = Date().toYearMonthString()
        let day = Date().toDayString()
        self.repository.updateTotalCount(userID: userID, yearMonth: yearMonth, day: day) {
            NotificationCenter.default.post(name: AchievementUpdateUsecase.didUpdateAchievement,
                                            object: nil)
        }
    }
}
