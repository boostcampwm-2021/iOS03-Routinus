//
//  Participation.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/18.
//

import Foundation

struct Participation {
    let authCount: Int
    let challengeID: String
    let joinDate: String
    let userID: String

    init(participationDTO: ParticipationDTO) {
        let document = participationDTO.document?.fields
        self.authCount = Int(document?.authCount.integerValue ?? "") ?? 0
        self.challengeID = document?.challengeID.stringValue ?? ""
        self.joinDate = document?.joinDate.stringValue ?? ""
        self.userID = document?.userID.stringValue ?? ""
    }
}
