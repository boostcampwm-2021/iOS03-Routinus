//
//  ParticipationRepository.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/17.
//

import Foundation

import RoutinusDatabase

protocol ParticipationRepository {
    func fetchChallengeParticipation(userID: String,
                                     challengeID: String,
                                     completion: @escaping (Participation?) -> Void)

    func save(challengeID: String,
              joinDate: String)

    func updateAuthCount(challengeID: String)
}

extension RoutinusRepository: ParticipationRepository {
    func fetchChallengeParticipation(userID: String,
                                     challengeID: String,
                                     completion: @escaping (Participation?) -> Void) {
        RoutinusDatabase.challengeParticipation(userID: userID,
                                                challengeID: challengeID) { dto in
            guard let dto = dto,
                  dto.document != nil else {
                completion(nil)
                return
            }
            completion(Participation(participationDTO: dto))
        }
    }

    func save(challengeID: String, joinDate: String) {
        guard let userID = RoutinusRepository.userID() else { return }
        let dto = ParticipationDTO(authCount: 0, challengeID: challengeID, joinDate: joinDate, userID: userID)
        RoutinusDatabase.insertChallengeParticipation(dto: dto, completion: nil)
    }

    func updateAuthCount(challengeID: String) {
        guard let userID = RoutinusRepository.userID() else { return }
        RoutinusDatabase.updateChallengeParticipation(challengeID: challengeID,
                                                      userID: userID,
                                                      completion: nil)
    }
}
