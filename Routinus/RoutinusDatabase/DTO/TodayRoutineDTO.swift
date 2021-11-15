//
//  TodayRoutineDTO.swift
//  RoutinusDatabase
//
//  Created by 유석환 on 2021/11/08.
//

import Foundation

public struct TodayRoutineDTO {
    public var id: String
    public var challengeID: String
    public var categoryID: String
    public var title: String
    public var authCount: Int
    public var joinDate: String
    public var endDate: String

    public init(participation: ParticipationDTO, challenge: ChallengeDTO) {
        self.id = participation.document?.fields.userID.stringValue ?? ""
        self.challengeID = participation.document?.fields.challengeID.stringValue ?? ""
        self.categoryID = challenge.document?.fields.categoryID.stringValue ?? ""
        self.title = challenge.document?.fields.title.stringValue ?? ""
        self.authCount = Int(participation.document?.fields.authCount.integerValue ?? "") ?? 0
        self.joinDate = participation.document?.fields.joinDate.stringValue ?? ""
        self.endDate = challenge.document?.fields.endDate.stringValue ?? ""
    }
}
