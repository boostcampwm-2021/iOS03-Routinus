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
    var repository: ChallengeRepository
    
    init(repository: ChallengeRepository) {
        self.repository = repository
    }
    
    func fetchRecommendChallenge(completion: @escaping ([RecommendChallenge]) -> Void) {
        Task {
            let recommendChallengeList = await repository.fetchRecommendChallenge()
            var challengeList = recommendChallengeList.sorted { $0.participantCount > $1.participantCount }
            if challengeList.count > 5 {
                challengeList = challengeList[..<5].map { $0 }
            }
            completion(challengeList)
        }
    }
}
