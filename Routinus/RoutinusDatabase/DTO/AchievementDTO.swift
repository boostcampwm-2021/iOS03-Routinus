//
//  AchievementDTO.swift
//  RoutinusDatabase
//
//  Created by 유석환 on 2021/11/08.
//

import Foundation

public struct AchievementDTO: Codable {
    public let document: AchievementFields?
    
    init() {
        self.document = nil
    }
}

public struct AchievementFields: Codable {
    public let fields: AchievementField
}

public struct AchievementField: Codable {
    public struct TotalCount: Codable {
        public let integerValue: String
    }

    public struct Day: Codable {
        public let stringValue: String
    }

    public struct UserID: Codable {
        public let stringValue: String
    }

    public struct AchievementCount: Codable {
        public let integerValue: String
    }

    public struct YearMonth: Codable {
        public let stringValue: String
    }

    public let totalCount: TotalCount
    public let day: Day
    public let userID: UserID
    public let achievementCount: AchievementCount
    public let yearMonth: YearMonth

    public enum CodingKeys: String, CodingKey {
        case day
        case totalCount = "total_count"
        case userID = "user_id"
        case achievementCount = "achievement_count"
        case yearMonth = "year_month"
    }
}
