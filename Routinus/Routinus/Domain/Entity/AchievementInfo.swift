//
//  AchievementInfo.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/03.
//

import Foundation

import RoutinusNetwork

struct AchievementInfo {
    let yearMonth: String
    let day: String
    let achievementCount: Int
    let totalCount: Int
    
    init(achievementDTO: AchievementInfoDTO) {
//        self.yearMonth = achievementDTO.yearMonth
//        self.day = achievementDTO.day
        self.achievementCount = achievementDTO.achievementCount
        self.totalCount = achievementDTO.totalCount
    }
}
