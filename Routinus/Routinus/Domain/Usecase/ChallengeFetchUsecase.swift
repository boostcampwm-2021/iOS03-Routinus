//
//  ChallengeFetchUsecase.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/08.
//

import Foundation

protocol ChallengeFetchableUsecase {
    func fetchRecommendChallenges(completion: @escaping ([Challenge]) -> Void)
    func fetchLatestChallenges(completion: @escaping ([Challenge]) -> Void)
    func fetchSearchChallenges(keyword: String,
                               completion: @escaping ([Challenge]) -> Void)
    func fetchSearchChallenges(category: Challenge.Category,
                               completion: @escaping ([Challenge]) -> Void)
    func fetchCreationChallengesByMe(completion: @escaping ([Challenge]) -> Void)
    func fetchEdittingChallenge(challengeID: String,
                                completion: @escaping (Challenge?) -> Void)
    func fetchChallenge(challengeID: String,
                        completion: @escaping (Challenge) -> Void)
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

    func fetchLatestChallenges(completion: @escaping ([Challenge]) -> Void) {
        Task {
            let list = await repository.fetchLatestChallenges()
            let challenges = list
                .sorted { $0.participantCount > $1.participantCount }
            completion(challenges)
        }
    }

    func fetchSearchChallenges(keyword: String, completion: @escaping ([Challenge]) -> Void) {
        Task {
            let list = await repository.fetchSearchChallengesBy(keyword: keyword)
            let keywords = keyword.components(separatedBy: " ")
            var results: Set<Challenge> = []

            let challenges = list
            keywords.forEach { keyword in
                list.filter { challenge in
                    challenge.title.contains(keyword)
                }.forEach { results.insert($0) }
            }
            completion(challenges)
        }
    }

    func fetchSearchChallenges(category: Challenge.Category, completion: @escaping ([Challenge]) -> Void) {
        Task {
            let categoryID = category.id
            let list =  await repository.fetchSearchChallengesBy(categoryID: categoryID)
            let challenges = list
                .filter { $0.category == category }
            completion(challenges)
        }
    }

    func fetchCreationChallengesByMe(completion: @escaping ([Challenge]) -> Void) {
        Task {
            guard let id = RoutinusRepository.userID() else { return }

            let list = await repository.fetchChallenges(by: id)
            let challengeList = list
            completion(challengeList)
        }
    }

    func fetchEdittingChallenge(challengeID: String,
                                completion: @escaping (Challenge?) -> Void) {
        repository.fetchEdittingChallenge(challengeID: challengeID) { challenge in
            completion(challenge)
        }
    }

    func fetchChallenge(challengeID: String,
                        completion: @escaping (Challenge) -> Void) {
        repository.fetchChallenge(challengeID: challengeID) { challenge in
            completion(challenge)
        }
    }
}
