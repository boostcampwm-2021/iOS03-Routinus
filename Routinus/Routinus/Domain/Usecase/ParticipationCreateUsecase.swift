//
//  ParticipationCreateUsecase.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/18.
//

import Foundation

protocol ParticipationCreatableUsecase {
    func createParticipation(challengeID: String)
}

struct ParticipationCreateUsecase: ParticipationCreatableUsecase {
    var repository: ParticipationRepository

    init(repository: ParticipationRepository) {
        self.repository = repository
    }

    func createParticipation(challengeID: String) {
        let date = Date().toDateString()
        repository.save(challengeID: challengeID, joinDate: date)
    }
}
