//
//  ChallengeAuthDTO.swift
//  RoutinusDatabase
//
//  Created by 박상우 on 2021/11/17.
//

import Foundation

public struct ChallengeAuthDTO: Codable {
    public let document: ChallengeAuthFields?

    init() {
        self.document = nil
    }

    public init(challengeID: String,
                userID: String,
                date: String,
                time: String) {
        let field = ChallengeAuthField(challengeID: StringField(stringValue: challengeID),
                                       userID: StringField(stringValue: userID),
                                       date: StringField(stringValue: date),
                                       time: StringField(stringValue: time))
        self.document = ChallengeAuthFields(fields: field)
    }
}

public struct ChallengeAuthFields: Codable {
    public let fields: ChallengeAuthField
}

public struct ChallengeAuthField: Codable {
    public let challengeID: StringField
    public let userID: StringField
    public let date: StringField
    public let time: StringField

    public enum CodingKeys: String, CodingKey {
        case date, time
        case challengeID = "challenge_id"
        case userID = "user_id"
    }
}
