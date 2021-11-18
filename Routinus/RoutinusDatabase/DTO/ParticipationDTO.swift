//
//  ParticipationDTO.swift
//  RoutinusDatabase
//
//  Created by 유석환 on 2021/11/14.
//

import Foundation

public struct ParticipationDTO: Codable {
    public let document: ParticipationFields?

    init() {
        self.document = nil
    }

    public init(authCount: Int, challengeID: String, joinDate: String, userID: String) {
        let field = ParticipationField(authCount: ParticipationField.AuthCount(integerValue: String(authCount)),
                                       challengeID: ParticipationField.ChallengeID(stringValue: challengeID),
                                       joinDate: ParticipationField.JoinDate(stringValue: joinDate),
                                       userID: ParticipationField.UserID(stringValue: userID))
        self.document = ParticipationFields(fields: field)
    }

    var documentID: String? {
        return self.document?.name?.components(separatedBy: "/").last
    }
}

public struct ParticipationFields: Codable {
    public var name: String?
    public let fields: ParticipationField
}

public struct ParticipationField: Codable {
    public struct AuthCount: Codable {
        public let integerValue: String
    }

    public struct ChallengeID: Codable {
        public let stringValue: String
    }

    public struct JoinDate: Codable {
        public let stringValue: String
    }

    public struct UserID: Codable {
        public let stringValue: String
    }

    public let authCount: AuthCount
    public let challengeID: ChallengeID
    public let joinDate: JoinDate
    public let userID: UserID

    public enum CodingKeys: String, CodingKey {
        case authCount = "auth_count"
        case challengeID = "challenge_id"
        case joinDate = "join_date"
        case userID = "user_id"
    }
}
