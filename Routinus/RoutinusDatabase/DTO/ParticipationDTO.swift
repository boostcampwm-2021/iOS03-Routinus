//
//  ParticipationDTO.swift
//  RoutinusDatabase
//
//  Created by 유석환 on 2021/11/14.
//

import Foundation

public struct ParticipationDTO: Codable {
    public let document: Fields<ParticipationFields>?

    init() {
        self.document = nil
    }

    public init(authCount: Int,
                challengeID: String,
                joinDate: String,
                userID: String) {
        let field = ParticipationFields(authCount: IntegerField(integerValue: "\(authCount)"),
                                        challengeID: StringField(stringValue: challengeID),
                                        joinDate: StringField(stringValue: joinDate),
                                        userID: StringField(stringValue: userID))
        self.document = Fields(name: nil, fields: field)
    }

    var documentID: String? {
        return self.document?.name?.components(separatedBy: "/").last
    }
}

public struct ParticipationFields: Codable {
    public let authCount: IntegerField
    public let challengeID: StringField
    public let joinDate: StringField
    public let userID: StringField

    public enum CodingKeys: String, CodingKey {
        case authCount = "auth_count"
        case challengeID = "challenge_id"
        case joinDate = "join_date"
        case userID = "user_id"
    }
}
