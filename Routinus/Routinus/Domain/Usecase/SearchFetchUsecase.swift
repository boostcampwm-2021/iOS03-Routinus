//
//  SearchFetchUsecase.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/09.
//

import Foundation

import RoutinusDatabase

protocol SearchFetchableUsecase {
    func fetchPopularKeywords(completion: @escaping ([String]) -> Void)
    func fetchLatestChallenges(completion: @escaping ([Challenge]) -> Void)
    func fetchSearchChallengeBy(keyword: String, completion: @escaping ([Challenge]) -> Void)
    func fetchSearchChallenges(by: Challenge.Category, completion: @escaping ([Challenge]) -> Void)
}

struct SearchFetchUsecase: SearchFetchableUsecase {
    var repository: SearchRepository

    init(repository: SearchRepository) {
        self.repository = repository
    }

    func fetchPopularKeywords(completion: @escaping ([String]) -> Void) {
        let keywords = PopularKeyword.allCases.map { $0.rawValue }
        completion(keywords)
    }

    func fetchLatestChallenges(completion: @escaping ([Challenge]) -> Void) {
        Task {
            let list = await repository.fetchLatestChallenges()
            let challenges = list
                .sorted { $0.participantCount > $1.participantCount }
            completion(challenges)
        }
    }

    func fetchSearchChallengeBy(keyword: String, completion: @escaping ([Challenge]) -> Void) {
        Task {
            let list = await repository.fetchSearchChallengesBy(keyword: keyword)
            let keywords = searchKeywords(keyword)
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

    func fetchSearchChallenges(by category: Challenge.Category, completion: @escaping ([Challenge]) -> Void) {
        Task {
            let categoryID = category.id
            let list =  await repository.fetchSearchChallengesBy(categoryID: categoryID)
            let challenges = list
                .filter { $0.category == category }
            completion(challenges)
        }
    }

    private func searchKeywords(_ keyword: String) -> [String] {
        let keywords = keyword.components(separatedBy: " ")
        return keywords
    }
}
