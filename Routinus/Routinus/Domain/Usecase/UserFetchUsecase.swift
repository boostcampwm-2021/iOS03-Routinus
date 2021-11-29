//
//  UserFetchUsecase.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/17.
//

import Foundation

protocol UserFetchableUsecase {
    func fetchUser(id: String, completion: @escaping (User) -> Void)
    func fetchUserID() -> String?
    func fetchThemeStyle() -> Int
}

struct UserFetchUsecase: UserFetchableUsecase {
    var repository: UserRepository

    init(repository: UserRepository) {
        self.repository = repository
    }

    func fetchUser(id: String, completion: @escaping (User) -> Void) {
        repository.fetchUser(by: id) { user in
            completion(user)
        }
    }

    func fetchUserID() -> String? {
        return RoutinusRepository.userID()
    }

    func fetchThemeStyle() -> Int {
        return repository.fetchThemeStyle()
    }
}
