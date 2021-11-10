//
//  ChallengeFetchUsecase.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/08.
//

import Foundation

import RoutinusDatabase

protocol ChallengeFetchableUsecase {
    func fetchRecommendChallenge(completion: @escaping ([Challenge]) -> Void)
}

struct ChallengeFetchUsecase: ChallengeFetchableUsecase {
    var repository: ChallengeRepository
    
    init(repository: ChallengeRepository) {
        self.repository = repository
    }
    
    func fetchRecommendChallenge(completion: @escaping ([Challenge]) -> Void) {
        Task {
            let recommendChallengeList = await repository.fetchRecommendChallenges()
            completion(recommendChallengeList)
        }
    }
}
