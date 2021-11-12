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
    func fetchLatestChallenge(completion: @escaping ([Challenge]) -> Void)
    func fetchSearchChallengeBy(keyword: String, completion: @escaping ([Challenge]) -> Void)
    func fetchSearchChallengeBy(category: Challenge.Category, completion: @escaping ([Challenge]) -> Void)
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

    func fetchLatestChallenge(completion: @escaping ([Challenge]) -> Void) {
        Task {
            let list = await repository.fetchNewChallenges()
            let challengeList = list
                .sorted { $0.participantCount > $1.participantCount }
            completion(challengeList)
        }
    }

    func fetchSearchChallengeBy(keyword: String, completion: @escaping ([Challenge]) -> Void) {
        Task {
            let list = await repository.fetchSearchChallengesBy(keyword: keyword)
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
            let categoryID = "\(category)"
            let list =  await repository.fetchSearchChallengesBy(categoryID: categoryID)
            let challengeList = list
                .filter { $0.category == category }
            completion(challengeList)
        }
    }

    private func searchKeywords(_ keyword: String) -> [String] {
        let keywords = keyword.components(separatedBy: " ")
        return keywords
    }
}