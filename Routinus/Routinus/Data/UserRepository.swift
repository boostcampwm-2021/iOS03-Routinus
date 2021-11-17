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
    func save(id: String,
              name: String)
    func fetchUser(by id: String,
                   completion: ((User) -> Void)?)
}

extension RoutinusRepository: UserRepository {
    func isEmptyUserID() -> Bool {
        return UserDefaults.standard.string(forKey: RoutinusRepository.userIDKey) == nil
    }

    func save(id: String,
              name: String) {
        UserDefaults.standard.set(id,
                                  forKey: RoutinusRepository.userIDKey)
        RoutinusDatabase.createUser(id: id,
                                    name: name,
                                    completion: nil)
    }

    func fetchUser(by id: String,
                   completion: ((User) -> Void)?) {
        RoutinusDatabase.user(of: id) { dto in
            completion?(User(userDTO: dto))
        }
    }
}
