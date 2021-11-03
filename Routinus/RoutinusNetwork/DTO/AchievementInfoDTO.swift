//
//  AchievementInfoDTO.swift
//  RoutinusNetwork
//
//  Created by 유석환 on 2021/11/03.
//

import Foundation

public struct AchievementInfoDTO {
    var userUDID: String
    var day: Int
    var achievementCount: Int
    var totalCount: Int
    
    init() {
        self.userUDID = ""
        self.day = 0
        self.achievementCount = 0
        self.totalCount = 0
    }
    
    init(userUDID: String, day: Int, achievementCount: Int, totalCount: Int) {
        self.userUDID = userUDID
        self.day = day
        self.achievementCount = achievementCount
        self.totalCount = totalCount
    }
}
