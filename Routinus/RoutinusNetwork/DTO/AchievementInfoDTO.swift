//
//  AchievementInfoDTO.swift
//  RoutinusNetwork
//
//  Created by 유석환 on 2021/11/03.
//

import Foundation

public struct AchievementInfoDTO {
    public var userUDID: String
    public var day: Int
    public var achievementCount: Int
    public var totalCount: Int
    
    public init() {
        self.userUDID = ""
        self.day = 0
        self.achievementCount = 0
        self.totalCount = 0
    }
    
    public init(userUDID: String, day: Int, achievementCount: Int, totalCount: Int) {
        self.userUDID = userUDID
        self.day = day
        self.achievementCount = achievementCount
        self.totalCount = totalCount
    }
}
