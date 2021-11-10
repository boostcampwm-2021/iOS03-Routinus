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

    public init(achievement: [String: Any]?) {
        self.userID = achievement?["user_id"] as? String ?? ""
        self.yearMonth = achievement?["year_month"] as? String ?? ""
        self.day = achievement?["day"] as? String ?? ""
        self.achievementCount = achievement?["achievement_count"] as? Int ?? 0
        self.totalCount = achievement?["total_count"] as? Int ?? 0
    }
}
