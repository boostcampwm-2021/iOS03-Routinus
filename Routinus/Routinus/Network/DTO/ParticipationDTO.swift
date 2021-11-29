//
//  ParticipationDTO.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/29.
//

import Foundation

struct ParticipationDTO: Codable {
    let document: Fields<ParticipationFields>?

    init() {
        self.document = nil
    }

    init(authCount: Int,
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

struct ParticipationFields: Codable {
    let authCount: IntegerField
    let challengeID: StringField
    let joinDate: StringField
    let userID: StringField

    enum CodingKeys: String, CodingKey {
        case authCount = "auth_count"
        case challengeID = "challenge_id"
        case joinDate = "join_date"
        case userID = "user_id"
    }
}
