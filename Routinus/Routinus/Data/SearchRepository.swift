//
//  SearchRepository.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/09.
//

import Foundation

import RoutinusDatabase
import RoutinusImageManager

protocol SearchRepository {
    func fetchSearchChallengesBy(keyword: String) async -> [Challenge]
    func fetchSearchChallengesBy(categoryID: String) async -> [Challenge]
    func fetchLatestChallenges() async -> [Challenge]
    func fetchImageData(from directory: String,
                        filename: String,
                        completion: ((Data?) -> Void)?)
}

extension RoutinusRepository: SearchRepository {
    func fetchSearchChallengesBy(keyword: String) async -> [Challenge] {
        guard let list = try? await RoutinusDatabase.latestChallenges() else { return [] }
        return list.map { Challenge(challengeDTO: $0) }
                .filter { $0.title.contains(keyword) }
    }

    func fetchSearchChallengesBy(categoryID: String) async -> [Challenge] {
        guard let list = try? await RoutinusDatabase.searchChallenges(categoryID: categoryID) else { return [] }
        return list.map { Challenge(challengeDTO: $0) }
    }

    func fetchLatestChallenges() async -> [Challenge] {
        guard let list = try? await RoutinusDatabase.newChallenges() else { return [] }
        return list.map { Challenge(challengeDTO: $0) }
    }

    func fetchImageData(from directory: String,
                        filename: String,
                        completion: ((Data?) -> Void)? = nil) {
        if RoutinusImageManager.isExist(in: directory, filename: filename) {
            RoutinusImageManager.cachedImageData(from: directory, filename: filename) { data in
                completion?(data)
            }
        } else {
            RoutinusDatabase.imageData(from: directory, filename: filename) { data in
                RoutinusImageManager.saveImage(to: directory, filename: filename, imageData: data)
                completion?(data)
            }
        }
    }
}
