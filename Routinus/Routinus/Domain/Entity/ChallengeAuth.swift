//
//  ChallengeAuth.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/17.
//

import Foundation

import RoutinusNetwork

struct ChallengeAuth {
    var challengeID: String
    var userID: String
    var date: Date?
    var time: Date?

    init(challengeID: String,
         userID: String,
         date: Date?,
         time: Date?) {
        self.challengeID = challengeID
        self.userID = userID
        self.date = date
        self.time = time
    }

    init(challengeAuthDTO: ChallengeAuthDTO) {
        let document = challengeAuthDTO.document?.fields

        self.challengeID = document?.challengeID.stringValue ?? ""
        self.userID = document?.userID.stringValue ?? ""
        self.date = Date(dateString: document?.date.stringValue ?? "")
        self.time = Date(timeString: document?.time.stringValue ?? "")
    }
}
