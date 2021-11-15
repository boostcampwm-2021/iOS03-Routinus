//
//  ChallengeFetchUsecase.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/08.
//

import Foundation

protocol ChallengeFetchableUsecase {
    func fetchRecommendChallenges(completion: @escaping ([Challenge]) -> Void)
}

struct ChallengeFetchUsecase: ChallengeFetchableUsecase {
    var repository: ChallengeRepository

    init(repository: ChallengeRepository) {
        self.repository = repository
    }

    func fetchRecommendChallenges(completion: @escaping ([Challenge]) -> Void) {
        Task {
            let recommendChallenges = await repository.fetchRecommendChallenges()
            completion(recommendChallenges)
        }
    }
}
