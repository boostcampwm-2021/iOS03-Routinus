//
//  AchievementDTO.swift
//  RoutinusDatabase
//
//  Created by 유석환 on 2021/11/08.
//

import Foundation

public struct AchievementDTO: Codable {
    public let document: Fields<AchievementFields>?

    init() {
        self.document = nil
    }

    public init(totalCount: Int,
                day: String,
                userID: String,
                achievementCount: Int,
                yearMonth: String) {
        let field = AchievementFields(totalCount: IntegerField(integerValue: "\(totalCount)"),
                                     day: StringField(stringValue: day),
                                     userID: StringField(stringValue: userID),
                                     achievementCount: IntegerField(integerValue: "\(achievementCount)"),
                                     yearMonth: StringField(stringValue: yearMonth))
        self.document = Fields(name: nil, fields: field)
    }

    var documentID: String? {
        return self.document?.name?.components(separatedBy: "/").last
    }
}

public struct AchievementFields: Codable {
    public let totalCount: IntegerField
    public let day: StringField
    public let userID: StringField
    public let achievementCount: IntegerField
    public let yearMonth: StringField

    public enum CodingKeys: String, CodingKey {
        case day
        case totalCount = "total_count"
        case userID = "user_id"
        case achievementCount = "achievement_count"
        case yearMonth = "year_month"
    }
}
