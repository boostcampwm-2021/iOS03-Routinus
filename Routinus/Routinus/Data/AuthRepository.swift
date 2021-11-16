//
//  AuthRepository.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/17.
//

import Foundation

import RoutinusDatabase

protocol AuthRepository {
    func fetchAuthChallenge(challengeID: String) async -> Challenge?
}

extension RoutinusRepository: AuthRepository {
    func fetchAuthChallenge(challengeID: String) async -> Challenge? {
        guard let challengeDTO = try? await RoutinusDatabase.challenge(challengeID: challengeID) else { return nil }
        return Challenge(challengeDTO: challengeDTO)
    }
}
