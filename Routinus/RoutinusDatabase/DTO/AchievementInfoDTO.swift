//
//  AchievementInfoDTO.swift
//  RoutinusDatabase
//
//  Created by 유석환 on 2021/11/08.
//

import Foundation

public struct AchievementInfoDTO {
    public var userID: String
    public var yearMonth: String
    public var day: String
    public var achievementCount: Int
    public var totalCount: Int

    public init() {
        self.userID = ""
        self.yearMonth = ""
        self.day = ""
        self.achievementCount = 0
        self.totalCount = 0
    }

    public init(userID: String, yearMonth: String, day: String, achievementCount: Int, totalCount: Int) {
        self.userID = userID
        self.yearMonth = yearMonth
        self.day = day
        self.achievementCount = achievementCount
        self.totalCount = totalCount
    }
}
