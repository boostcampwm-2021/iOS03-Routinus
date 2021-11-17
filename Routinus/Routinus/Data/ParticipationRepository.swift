//
//  ParticipationRepository.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/17.
//

import Foundation
import RoutinusDatabase

protocol ParticipationRepository {
    func fetchChallengeParticipation(userID: String, challengeID: String, completion: @escaping (Participation?) -> Void)
}

extension RoutinusRepository: ParticipationRepository {
    func fetchChallengeParticipation(userID: String, challengeID: String, completion: @escaping (Participation?) -> Void) {
        RoutinusDatabase.challengeParticipation(userID: userID, challengeID: challengeID) { dto in
            guard let dto = dto else {
                completion(nil)
                return
            }
            completion(Participation(participationDTO: dto))
        }
    }
}
