//
//  AuthDTO.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/29.
//

import Foundation

struct AuthDTO: Codable {
    let document: Fields<AuthFields>?

    init() {
        self.document = nil
    }

    init(challengeID: String, userID: String, date: String, time: String) {
        let field = AuthFields(challengeID: StringField(stringValue: challengeID),
                               userID: StringField(stringValue: userID),
                               date: StringField(stringValue: date),
                               time: StringField(stringValue: time))
        self.document = Fields(name: nil, fields: field)
    }
}

struct AuthFields: Codable {
    let challengeID: StringField
    let userID: StringField
    let date: StringField
    let time: StringField

    enum CodingKeys: String, CodingKey {
        case date, time
        case challengeID = "challenge_id"
        case userID = "user_id"
    }
}
