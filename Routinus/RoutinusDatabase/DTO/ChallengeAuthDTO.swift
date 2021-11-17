//
//  ChallengeAuthDTO.swift
//  RoutinusDatabase
//
//  Created by 박상우 on 2021/11/17.
//

import Foundation

public struct ChallengeAuthDTO {
    public let document: ChallengeAuthFields?

    init() {
        self.document = nil
    }
    
    public init(challengeID: String,
                userID: String,
                date: String,
                time: String) {
        let field = ChallengeAuthField(challengeID: ChallengeAuthField.ChallengeID(stringValue: challengeID),
                                       userID: ChallengeAuthField.UserID(stringValue: userID),
                                       date: ChallengeAuthField.Date(stringValue: date),
                                       time: ChallengeAuthField.Time(stringValue: time))
        self.document = ChallengeAuthFields(fields: field)
    }
}

public struct ChallengeAuthFields: Codable {
    public let fields: ChallengeAuthField
}

public struct ChallengeAuthField: Codable {
    public struct ChallengeID: Codable {
        public let stringValue: String
    }

    public struct UserID: Codable {
        public let stringValue: String
    }

    public struct Date: Codable {
        public let stringValue: String
    }

    public struct Time: Codable {
        public let stringValue: String
    }

    public let challengeID: ChallengeID
    public let userID: UserID
    public let date: Date
    public let time: Time

    public enum CodingKeys: String, CodingKey {
        case date, time
        case challengeID = "challenge_id"
        case userID = "user_id"
    }
}
