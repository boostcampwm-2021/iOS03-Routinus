//
//  AchievementUpdateUsecase.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/18.
//

import Foundation

protocol AchievementUpdatableUsecase {
    func updateAchievementCount()
}

struct AchievementUpdateUsecase: AchievementUpdatableUsecase {
    var repository: AchievementRepository

    init(repository: AchievementRepository) {
        self.repository = repository
    }

    func updateAchievementCount() {
        guard let userID = RoutinusRepository.userID() else { return }
        let yearMonth = Date().toYearMonthString()
        let day = Date().toDayString()
        self.repository.updateAchievement(userID: userID,
                                          yearMonth: yearMonth,
                                          day: day)
    }
   
}
