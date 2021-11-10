//
//  SearchFetchUsecase.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/09.
//

import Foundation

import RoutinusDatabase

protocol SearchFetchableUsecase {
    func fetchPopularChallenge(completion: @escaping ([Challenge]) -> Void)
    func fetchSearchChallengeBy(keyword: String, completion: @escaping ([Challenge]) -> Void)
    func fetchSearchChallengeBy(category: Challenge.Category, completion: @escaping ([Challenge]) -> Void)
}

struct SearchFetchUsecase: SearchFetchableUsecase {
    var repository: SearchRepository

    init(repository: SearchRepository) {
        self.repository = repository
    }

    func fetchPopularChallenge(completion: @escaping ([Challenge]) -> Void) {
        Task {
            let list = await repository.fetchChallenges()
            var challengeList = list
                .sorted { $0.participantCount > $1.participantCount }
            if challengeList.count > 6 {
                challengeList = challengeList[..<6].map { $0 }
            }
            completion(challengeList)
        }
    }

    func fetchSearchChallengeBy(keyword: String, completion: @escaping ([Challenge]) -> Void) {
        Task {
            let list = await repository.fetchChallenges()
            let keywords = searchKeywords(keyword)
            var results: Set<Challenge> = []

            let challengeList = list
            keywords.forEach { keyword in
                list.filter { challenge in
                    challenge.title.contains(keyword)
                }.forEach { results.insert($0) }
            }
            completion(challengeList)
        }
    }

    func fetchSearchChallengeBy(category: Challenge.Category, completion: @escaping ([Challenge]) -> Void) {
        Task {
            guard let list = try? await RoutinusDatabase.allChallenges() else { return }
            let challengeList = list
                .map { Challenge(challengeDTO: $0) }
                .filter { $0.category == category }
            completion(challengeList)
        }
    }

    private func searchKeywords(_ keyword: String) -> [String] {
        let keywords = keyword.components(separatedBy: " ")
        return keywords
    }
}
