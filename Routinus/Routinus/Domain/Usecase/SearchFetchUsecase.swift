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
    func fetchSearchKeyword(keyword: String, completion: @escaping ([Challenge]) -> Void)
}

struct SearchFetchUsecase: SearchFetchableUsecase {
    func fetchPopularChallenge(completion: @escaping ([Challenge]) -> Void) {
        Task {
            guard let list = try? await RoutinusDatabase.challengeInfo() else { return }
            var challengeList = list
                .map { Challenge(challengeDTO: $0) }
                .sorted { $0.participantCount > $1.participantCount }
            if challengeList.count > 6 {
                challengeList = challengeList[..<6].map { $0 }
            }
            completion(challengeList)
        }
    }

    func fetchSearchKeyword(keyword: String, completion: @escaping ([Challenge]) -> Void) {
        Task {
            guard let list = try? await RoutinusDatabase.challengeInfo() else { return }
            let challengeList = list
                .map { Challenge(challengeDTO: $0) }
                .filter { $0.title.contains(keyword) || $0.description.contains(keyword) }
            completion(challengeList)
        }
    }

    func fetchSearchCategory(categoryID: String, completion: @escaping ([Challenge]) -> Void) {
        Task {
            guard let list = try? await RoutinusDatabase.challengeInfo() else { return }
            let challengeList = list
                .map { Challenge(challengeDTO: $0) }
                .filter { $0.categoryID == categoryID }
            completion(challengeList)
        }
    }
}
