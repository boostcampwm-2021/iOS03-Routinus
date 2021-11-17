//
//  UserRepository.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/17.
//

import Foundation

import RoutinusDatabase

protocol UserRepository {
    func isEmptyUserID() -> Bool
    func save(id: String, name: String)
    func fetchUser(by id: String) async -> User
}

extension RoutinusRepository: UserRepository {
    func isEmptyUserID() -> Bool {
        return UserDefaults.standard.string(forKey: RoutinusRepository.userIDKey) == nil
    }

    func save(id: String,
              name: String) {
        UserDefaults.standard.set(id, forKey: RoutinusRepository.userIDKey)

        Task {
            try await RoutinusDatabase.createUser(id: id, name: name)
        }
    }

    func fetchUser(by id: String) async -> User {
        guard let userDTO = try? await RoutinusDatabase.user(of: id) else { return User() }
        return User(userDTO: userDTO)
    }
}
