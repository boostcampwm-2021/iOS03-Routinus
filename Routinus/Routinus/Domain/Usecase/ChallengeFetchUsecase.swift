//
//  ChallengeFetchUsecase.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/08.
//

import Foundation

import RoutinusDatabase

protocol ChallengeFetchableUsecase {
    func fetchRecommendChallenge(completion: @escaping ([RecommendChallenge]) -> Void)
}

struct ChallengeFetchUsecase: ChallengeFetchableUsecase {
    func fetchRecommendChallenge(completion: @escaping ([RecommendChallenge]) -> Void) {
        Task {
            guard let list = try? await RoutinusDatabase.challengeInfo() else { return }
            var challengeList = list
                .map { RecommendChallenge(challengeDTO: $0) }
                .sorted { $0.participantCount > $1.participantCount }
            if challengeList.count > 5 {
                challengeList = challengeList[..<5].map { $0 }
            }
            completion(challengeList)
        }
    }
}