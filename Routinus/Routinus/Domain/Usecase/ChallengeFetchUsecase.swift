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
    func fetchCreatedChallengesByMe(completion: @escaping ([Challenge]) -> Void)
    func fetchMyParticipatingChallenges(completion: @escaping ([Challenge]) -> Void)
    func fetchMyEndedChallenges(completion: @escaping ([Challenge]) -> Void)
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
        repository.fetchRecommendChallenges { challenges in
            completion(challenges.filter { $0.endDate ?? Date() >= Date() })
        }
    }

    func fetchLatestChallenges(completion: @escaping ([Challenge]) -> Void) {
        repository.fetchLatestChallenges { challenges in
            let challenges = challenges
                .filter { $0.endDate ?? Date() >= Date() }
                .sorted { $0.participantCount > $1.participantCount }
            completion(challenges)
        }
    }

    func fetchSearchChallenges(keyword: String,
                               completion: @escaping ([Challenge]) -> Void) {
        repository.fetchSearchChallengesBy(keyword: keyword) { list in
            let keywords = keyword.components(separatedBy: " ")
            var results: Set<Challenge> = []

            keywords.forEach { keyword in
                list.filter { challenge in
                    challenge.title.contains(keyword)
                }.forEach {
                    results.insert($0)
                }
            }
            completion(Array(results))
        }
    }

    func fetchSearchChallenges(category: Challenge.Category,
                               completion: @escaping ([Challenge]) -> Void) {
        let categoryID = category.id
        repository.fetchSearchChallengesBy(categoryID: categoryID) { list in
            let challenges = list.filter { $0.category == category }
            completion(challenges)
        }
    }

    func fetchCreatedChallengesByMe(completion: @escaping ([Challenge]) -> Void) {
        guard let id = RoutinusRepository.userID() else { return }
        repository.fetchChallenges(by: id) { challenges in
            completion(challenges.filter { $0.endDate ?? Date() >= Date() })
        }
    }

    func fetchMyParticipatingChallenges(completion: @escaping ([Challenge]) -> Void) {
        guard let id = RoutinusRepository.userID() else { return }
        repository.fetchChallenges(of: id) { challenges in
            completion(challenges.filter { $0.endDate ?? Date() >= Date() }.filter { $0.ownerID != id })
        }
    }

    func fetchMyEndedChallenges(completion: @escaping ([Challenge]) -> Void) {
        guard let id = RoutinusRepository.userID() else { return }
        repository.fetchChallenges(of: id) { challenges in
            completion(challenges.filter { $0.endDate ?? Date() < Date()  })
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
