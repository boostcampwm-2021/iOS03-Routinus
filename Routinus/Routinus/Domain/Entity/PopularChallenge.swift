//
//  PopularChallenge.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/08.
//

import Foundation

struct PopularChallenge {
    let challengeID: String
    let title: String
    let description: String
    let participantCount: Int
    
    init(challengeID: String, title: String, description: String, participantCount: Int) {
        self.challengeID = challengeID
        self.title = title
        self.description = description
        self.participantCount = participantCount
    }
}
