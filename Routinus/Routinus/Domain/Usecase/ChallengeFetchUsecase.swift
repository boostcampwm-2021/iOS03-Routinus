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
    func fetchSearchChallenges(keyword: String, completion: @escaping ([Challenge]) -> Void)
    func fetchSearchChallenges(category: Challenge.Category,
                               completion: @escaping ([Challenge]) -> Void)
    func fetchCreatedChallengesByMe(completion: @escaping ([Challenge]) -> Void)
    func fetchMyParticipatingChallenges(completion: @escaping ([Challenge]) -> Void)
    func fetchMyEndedChallenges(completion: @escaping ([Challenge]) -> Void)
    func fetchEdittingChallenge(challengeID: String, completion: @escaping (Challenge?) -> Void)
    func fetchChallenge(challengeID: String, completion: @escaping (Challenge) -> Void)
}

struct ChallengeFetchUsecase: ChallengeFetchableUsecase {
    var repository: ChallengeRepository

    init(repository: ChallengeRepository) {
        self.repository = repository
    }

    func fetchRecommendChallenges(completion: @escaping ([Challenge]) -> Void) {
        repository.fetchRecommendChallenges { challenges in
            completion(challenges.filter {
                $0.endDate?.toDateString() ?? Date().toDateString() > Date().toDateString()
            })
        }
    }

    func fetchLatestChallenges(completion: @escaping ([Challenge]) -> Void) {
        repository.fetchLatestChallenges { challenges in
            let challenges = challenges.filter {
                $0.endDate?.toDateString() ?? Date().toDateString() > Date().toDateString()
            }
            completion(challenges)
        }
    }

    func fetchSearchChallenges(keyword: String, completion: @escaping ([Challenge]) -> Void) {
        repository.fetchSearchChallengesBy(keyword: keyword) { challenges in
            let challenges = challenges.filter {
                $0.endDate?.toDateString() ?? Date().toDateString() > Date().toDateString()
            }
            let keywords = keyword.components(separatedBy: " ")
            var results: Set<Challenge> = []

            keywords.forEach { keyword in
                challenges.filter { challenge in
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
        repository.fetchSearchChallengesBy(categoryID: categoryID) { challenges in
            let challenges = challenges
                .filter { $0.endDate?.toDateString() ?? Date().toDateString() > Date().toDateString() }
                .filter { $0.category == category }
            completion(challenges)
        }
    }

    func fetchCreatedChallengesByMe(completion: @escaping ([Challenge]) -> Void) {
        guard let id = RoutinusRepository.userID() else { return }
        repository.fetchChallenges(by: id) { challenges in
            completion(challenges.filter { $0.endDate?.toDateString() ?? Date().toDateString() > Date().toDateString() })
        }
    }

    func fetchMyParticipatingChallenges(completion: @escaping ([Challenge]) -> Void) {
        guard let id = RoutinusRepository.userID() else { return }
        repository.fetchChallenges(of: id) { challenges in
            completion(challenges
                        .filter { $0.endDate?.toDateString() ?? Date().toDateString() > Date().toDateString() }
                        .filter { $0.ownerID != id })
        }
    }

    func fetchMyEndedChallenges(completion: @escaping ([Challenge]) -> Void) {
        guard let id = RoutinusRepository.userID() else { return }
        repository.fetchChallenges(of: id) { challenges in
            completion(challenges.filter { $0.endDate?.toDateString() ?? Date().toDateString() <= Date().toDateString() })
        }
    }

    func fetchEdittingChallenge(challengeID: String, completion: @escaping (Challenge?) -> Void) {
        repository.fetchEdittingChallenge(challengeID: challengeID) { challenge in
            completion(challenge)
        }
    }

    func fetchChallenge(challengeID: String, completion: @escaping (Challenge) -> Void) {
        repository.fetchChallenge(challengeID: challengeID) { challenge in
            completion(challenge)
        }
    }
}
