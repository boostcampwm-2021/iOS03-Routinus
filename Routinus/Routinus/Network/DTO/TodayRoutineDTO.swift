//
//  TodayRoutineDTO.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/29.
//

import Foundation

struct TodayRoutineDTO {
    var id: String
    var challengeID: String
    var categoryID: String
    var title: String
    var authCount: Int
    var joinDate: String
    var endDate: String

    init(participation: ParticipationDTO, challenge: ChallengeDTO) {
        self.id = participation.document?.fields.userID.stringValue ?? ""
        self.challengeID = participation.document?.fields.challengeID.stringValue ?? ""
        self.categoryID = challenge.document?.fields.categoryID.stringValue ?? ""
        self.title = challenge.document?.fields.title.stringValue ?? ""
        self.authCount = Int(participation.document?.fields.authCount.integerValue ?? "") ?? 0
        self.joinDate = participation.document?.fields.joinDate.stringValue ?? ""
        self.endDate = challenge.document?.fields.endDate.stringValue ?? ""
    }
}
