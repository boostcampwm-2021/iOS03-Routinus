//
//  ParticipationFetchUsecase.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/18.
//

import Foundation

protocol ParticipationFetchableUsecase {
    func fetchParticipation(challengeID: String, completion: @escaping (Participation?) -> Void)
}

struct ParticipationFetchUsecase: ParticipationFetchableUsecase {
    var repository: ParticipationRepository

    init(repository: ParticipationRepository) {
        self.repository = repository
    }

    func fetchParticipation(challengeID: String, completion: @escaping (Participation?) -> Void) {
        guard let userID = RoutinusRepository.userID() else {
            completion(nil)
            return
        }
        repository.fetchParticipation(userID: userID, challengeID: challengeID) { participation in
            completion(participation)
        }
    }
}
