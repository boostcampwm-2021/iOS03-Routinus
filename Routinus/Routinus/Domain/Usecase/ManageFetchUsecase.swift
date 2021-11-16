//
//  ManageFetchUsecase.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/12.
//

import Foundation

import RoutinusDatabase

protocol ManageFetchableUsecase {
    func fetchChallenges(completion: @escaping ([Challenge]) -> Void)
}

struct ManageFetchUsecase: ManageFetchableUsecase {
    var repository: ManageRepository

    init(repository: ManageRepository) {
        self.repository = repository
    }

    func fetchChallenges(completion: @escaping ([Challenge]) -> Void) {
        Task {
            guard let id = RoutinusRepository.userID() else { return }

            let list = await repository.fetchChallenges(by: id)
            let challengeList = list
            completion(challengeList)
        }
    }
}
