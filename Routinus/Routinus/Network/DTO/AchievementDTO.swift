//
//  AchievementDTO.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/29.
//

import Foundation

struct AchievementDTO: Codable {
    let document: Fields<AchievementFields>?

    var documentID: String? {
        return document?.name?.components(separatedBy: "/").last
    }

    init() {
        self.document = nil
    }

    init(totalCount: Int, day: String, userID: String, achievementCount: Int, yearMonth: String) {
        let field = AchievementFields(
            totalCount: IntegerField(integerValue: "\(totalCount)"),
            day: StringField(stringValue: day),
            userID: StringField(stringValue: userID),
            achievementCount: IntegerField(integerValue: "\(achievementCount)"),
            yearMonth: StringField(stringValue: yearMonth)
        )
        self.document = Fields(name: nil, fields: field)
    }
}

struct AchievementFields: Codable {
    let totalCount: IntegerField
    let day: StringField
    let userID: StringField
    let achievementCount: IntegerField
    let yearMonth: StringField

    enum CodingKeys: String, CodingKey {
        case day
        case totalCount = "total_count"
        case userID = "user_id"
        case achievementCount = "achievement_count"
        case yearMonth = "year_month"
    }
}
