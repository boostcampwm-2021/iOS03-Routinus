//
//  ParticipationRepository.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/17.
//

import Foundation

protocol ParticipationRepository {
    func fetchChallengeParticipation(userID: String,
                                     challengeID: String,
                                     completion: @escaping (Participation?) -> Void)
    func save(challengeID: String, joinDate: String, completion: (() -> Void)?)
    func updateAuthCount(challengeID: String, completion: (() -> Void)?)
}

extension RoutinusRepository: ParticipationRepository {
    func fetchChallengeParticipation(userID: String,
                                     challengeID: String,
                                     completion: @escaping (Participation?) -> Void) {
        FirebaseService.challengeParticipation(userID: userID, challengeID: challengeID) { dto in
            guard let dto = dto, dto.document != nil else {
                completion(nil)
                return
            }
            completion(Participation(participationDTO: dto))
        }
    }

    func save(challengeID: String, joinDate: String, completion: (() -> Void)?) {
        guard let userID = RoutinusRepository.userID() else { return }
        let dto = ParticipationDTO(authCount: 0,
                                   challengeID: challengeID,
                                   joinDate: joinDate,
                                   userID: userID)
        FirebaseService.insertChallengeParticipation(dto: dto) {
            completion?()
        }
    }

    func updateAuthCount(challengeID: String, completion: (() -> Void)?) {
        guard let userID = RoutinusRepository.userID() else { return }
        FirebaseService.updateChallengeParticipationAuthCount(challengeID: challengeID,
                                                              userID: userID) {
            completion?()
        }
    }
}
