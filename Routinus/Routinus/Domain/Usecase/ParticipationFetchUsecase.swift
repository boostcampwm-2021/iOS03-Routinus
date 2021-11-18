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

    // TODO: auth 인증 fetch + escaping: (Participation?, Auth?) -> Void 로 전달
    func fetchParticipation(challengeID: String, completion: @escaping (Participation?) -> Void) {
        guard let userID = RoutinusRepository.userID() else {
            completion(nil)
            return }
        repository.fetchChallengeParticipation(userID: userID, challengeID: challengeID) { participation in
            completion(participation)
        }
    }
}
