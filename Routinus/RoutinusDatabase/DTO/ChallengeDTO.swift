//
//  ChallengeDTO.swift
//  RoutinusDatabase
//
//  Created by 박상우 on 2021/11/09.
//

import Foundation

public struct ChallengeDTO: Codable {
    public var document: Fields<ChallengeFields>?

    public init() {
        self.document = nil
    }

    public init(id: String,
                title: String,
                authMethod: String,
                categoryID: String,
                week: Int,
                desc: String,
                startDate: String,
                endDate: String,
                participantCount: Int,
                ownerID: String) {
        let field = ChallengeFields(authMethod: StringField(stringValue: authMethod),
                                   categoryID: StringField(stringValue: categoryID),
                                   desc: StringField(stringValue: desc),
                                   endDate: StringField(stringValue: endDate),
                                   id: StringField(stringValue: id),
                                   ownerID: StringField(stringValue: ownerID),
                                   participantCount: IntegerField(integerValue: "\(participantCount)"),
                                   startDate: StringField(stringValue: startDate),
                                   title: StringField(stringValue: title),
                                   week: IntegerField(integerValue: "\(week)"))
        self.document = Fields(name: nil, fields: field)
    }

    var documentID: String? {
        return self.document?.name?.components(separatedBy: "/").last
    }
}

public struct ChallengeFields: Codable {
    public var authMethod: StringField
    public var categoryID: StringField
    public var desc: StringField
    public var endDate: StringField
    public var id: StringField
    public var ownerID: StringField
    public var participantCount: IntegerField
    public var startDate: StringField
    public var title: StringField
    public var week: IntegerField

    public enum CodingKeys: String, CodingKey {
        case desc, id, title, week
        case authMethod = "auth_method"
        case categoryID = "category_id"
        case endDate = "end_date"
        case ownerID = "owner_id"
        case participantCount = "participant_count"
        case startDate = "start_date"
    }
}
