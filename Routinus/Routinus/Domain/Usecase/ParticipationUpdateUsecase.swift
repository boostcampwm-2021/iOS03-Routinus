//
//  ParticipationUpdateUsecase.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/18.
//

import Foundation

protocol ParticipationUpdatableUsecase {
    func updateParticipationAuthCount(challengeID: String)
}

struct ParticipationUpdateUsecase: ParticipationUpdatableUsecase {
    static let didUpdateParticipation = Notification.Name("didUpdateParticipation")

    var repository: ParticipationRepository

    init(repository: ParticipationRepository) {
        self.repository = repository
    }

    func updateParticipationAuthCount(challengeID: String) {
        repository.updateAuthCount(challengeID: challengeID) {
            NotificationCenter.default.post(name: ParticipationUpdateUsecase.didUpdateParticipation,
                                            object: nil)
        }
    }
}
