//
//  ChallengeCreateUsecase.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/09.
//

import Foundation

import RoutinusDatabase

protocol ChallengeCreatableUsecase {
    func createChallenge(challenge: CreateChallenge)
}

struct ChallengeCreateUsecase: ChallengeCreatableUsecase {
    var repository: CreateRepository

    init(repository: CreateRepository) {
        self.repository = repository
    }

    func createChallenge(challenge: CreateChallenge) {
        // TODO: 챌린지ID factory
        // TODO: startDate 설정
        // TODO: categoryID 설정
        // TODO: endDate 설정
        guard let ownerID = repository.userID() else { return }
        let challenge = ChallengeDTO(id: "aa", title: challenge.title, imageURL: challenge.id, authExampleImageURL: challenge.authImageURL, authMethod: challenge.authMethod, categoryID: "1", week: challenge.week, decs: challenge.description, startDate: "20211109", endDate: "20211209", participantCount: 0, ownerID: ownerID, thumbnailImageURL: "")
        repository.save(challenge: challenge)
    }
}
