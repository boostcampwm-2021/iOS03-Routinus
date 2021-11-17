//
//  AchievementRepository.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/17.
//

import Foundation

import RoutinusDatabase

protocol AchievementRepository {
    func fetchAcheivements(by id: String, in yearMonth: String) async -> [Achievement]
}

extension RoutinusRepository: AchievementRepository {
    func fetchAcheivements(by id: String, in yearMonth: String) async -> [Achievement] {
        guard let list = try? await RoutinusDatabase.achievement(of: id, in: yearMonth) else { return [] }
        return list.map { Achievement(achievementDTO: $0) }
    }
}
