//
//  AchievementRepository.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/17.
//

import Foundation

import RoutinusDatabase

protocol AchievementRepository {
    func fetchAchievements(by id: String,
                           in yearMonth: String,
                           completion: (([Achievement]) -> Void)?)

    func updateAchievementCount(userID: String, yearMonth: String, day: String)
}

extension RoutinusRepository: AchievementRepository {
    func fetchAchievements(by id: String,
                           in yearMonth: String,
                           completion: (([Achievement]) -> Void)?) {
        RoutinusDatabase.achievements(of: id, in: yearMonth) { list in
            completion?(list.map { Achievement(achievementDTO: $0) })
        }
    }

    func updateAchievementCount(userID: String, yearMonth: String, day: String) {
        RoutinusDatabase.updateAchievementCount(userID: userID,
                                                yearMonth: yearMonth,
                                                day: day,
                                                completion: nil)
    }
}
