//
//  AchievementRepository.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/17.
//

import Foundation

import RoutinusDatabase

protocol AchievementRepository {
    func fetchAcheivements(by id: String,
                           in yearMonth: String,
                           completion: (([Achievement]) -> Void)?)
}

extension RoutinusRepository: AchievementRepository {
    func fetchAcheivements(by id: String,
                           in yearMonth: String,
                           completion: (([Achievement]) -> Void)?) {
        RoutinusDatabase.achievements(of: id, in: yearMonth) { list in
            completion?(list.map { Achievement(achievementDTO: $0) })
        }
    }
}
