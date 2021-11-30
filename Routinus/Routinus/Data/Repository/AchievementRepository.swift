//
//  AchievementRepository.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/17.
//

import Foundation

protocol AchievementRepository {
    func fetchAchievements(by id: String,
                           in yearMonth: String,
                           completion: (([Achievement]) -> Void)?)
    func updateAchievementCount(userID: String,
                                yearMonth: String,
                                day: String,
                                completion: (() -> Void)?)
    func updateTotalCount(userID: String,
                          yearMonth: String,
                          day: String,
                          completion: (() -> Void)?)
}

extension RoutinusRepository: AchievementRepository {
    func fetchAchievements(by id: String,
                           in yearMonth: String,
                           completion: (([Achievement]) -> Void)?) {
        FirebaseService.achievements(of: id, in: yearMonth) { list in
            completion?(list.map { Achievement(achievementDTO: $0) })
        }
    }

    func updateAchievementCount(userID: String,
                                yearMonth: String,
                                day: String,
                                completion: (() -> Void)?) {
        FirebaseService.updateAchievementCount(userID: userID,
                                               yearMonth: yearMonth,
                                               day: day) {
            completion?()
        }
    }

    func updateTotalCount(userID: String,
                          yearMonth: String,
                          day: String,
                          completion: (() -> Void)?) {
        FirebaseService.updateTotalCount(userID: userID, yearMonth: yearMonth, day: day) {
            completion?()
        }
    }
}
