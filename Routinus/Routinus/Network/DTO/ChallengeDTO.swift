//
//  ChallengeDTO.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/29.
//

import Foundation

struct ChallengeDTO: Codable {
    var document: Fields<ChallengeFields>?

    init() {
        self.document = nil
    }

    init(id: String,
         title: String,
         authMethod: String,
         categoryID: String,
         week: Int,
         desc: String,
         startDate: String,
         endDate: String,
         participantCount: Int,
         ownerID: String) {
        let field = ChallengeFields(
            authMethod: StringField(stringValue: authMethod),
            categoryID: StringField(stringValue: categoryID),
            desc: StringField(stringValue: desc),
            endDate: StringField(stringValue: endDate),
            id: StringField(stringValue: id),
            ownerID: StringField(stringValue: ownerID),
            participantCount: IntegerField(integerValue: "\(participantCount)"),
            startDate: StringField(stringValue: startDate),
            title: StringField(stringValue: title),
            week: IntegerField(integerValue: "\(week)")
        )
        self.document = Fields(name: nil, fields: field)
    }

    var documentID: String? {
        return self.document?.name?.components(separatedBy: "/").last
    }
}

struct ChallengeFields: Codable {
    var authMethod: StringField
    var categoryID: StringField
    var desc: StringField
    var endDate: StringField
    var id: StringField
    var ownerID: StringField
    var participantCount: IntegerField
    var startDate: StringField
    var title: StringField
    var week: IntegerField

    enum CodingKeys: String, CodingKey {
        case desc, id, title, week
        case authMethod = "auth_method"
        case categoryID = "category_id"
        case endDate = "end_date"
        case ownerID = "owner_id"
        case participantCount = "participant_count"
        case startDate = "start_date"
    }
}
