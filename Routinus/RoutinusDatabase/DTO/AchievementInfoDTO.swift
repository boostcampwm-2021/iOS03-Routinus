//
//  AchievementInfoDTO.swift
//  RoutinusDatabase
//
//  Created by 유석환 on 2021/11/08.
//

import Foundation

public struct AchievementInfoDTO {
    public var userUDID: String
    public var yearMonth: String
    public var day: String
    public var achievementCount: Int
    public var totalCount: Int
    
    public init() {
        self.userUDID = ""
        self.yearMonth = ""
        self.day = ""
        self.achievementCount = 0
        self.totalCount = 0
    }
    
    public init(userUDID: String, yearMonth: String, day: String, achievementCount: Int, totalCount: Int) {
        self.userUDID = userUDID
        self.yearMonth = yearMonth
        self.day = day
        self.achievementCount = achievementCount
        self.totalCount = totalCount
    }
}
