//
//  AchievementInfo.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/03.
//

import Foundation

import RoutinusDatabase

struct AchievementInfo {
    let yearMonth: String
    let day: String
    let achievementCount: Int
    let totalCount: Int
    
    init(yearMonth: String, day: String, achievementCount: Int, totalCount: Int) {
        self.yearMonth = yearMonth
        self.day = day
        self.achievementCount = achievementCount
        self.totalCount = totalCount
    }

    init(achievementDTO: AchievementInfoDTO) {
        self.yearMonth = achievementDTO.yearMonth
        self.day = achievementDTO.day
        self.achievementCount = achievementDTO.achievementCount
        self.totalCount = achievementDTO.totalCount
    }
}
