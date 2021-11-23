//
//  UserRepository.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/17.
//

import Foundation

import RoutinusNetwork

protocol UserRepository {
    func isEmptyUserID() -> Bool
    func save(id: String,
              name: String,
              completion: ((UserDTO) -> Void)?)
    func fetchUser(by id: String,
                   completion: ((User) -> Void)?)
    func updateContinuityDayByAuth(by id: String)
    func fetchThemeStyle() -> Int
    func updateUsername(of id: String,
                        name: String)
    func updateThemeStyle(_ style: Int)
}

extension RoutinusRepository: UserRepository {
    func isEmptyUserID() -> Bool {
        return UserDefaults.standard.string(forKey: RoutinusRepository.userIDKey) == nil
    }

    func save(id: String,
              name: String,
              completion: ((UserDTO) -> Void)?) {
        UserDefaults.standard.set(id,
                                  forKey: RoutinusRepository.userIDKey)
        RoutinusNetwork.insertUser(id: id,
                                   name: name) { dto in
            guard let dto = dto else { return }
            completion?(dto)
        }
    }

    func fetchUser(by id: String,
                   completion: ((User) -> Void)?) {
        RoutinusNetwork.user(of: id) { dto in
            completion?(User(userDTO: dto))
        }
    }

    func updateContinuityDayByAuth(by id: String) {
        RoutinusNetwork.updateContinuityDayByAuth(of: id,
                                                  completion: nil)
    }

    func fetchThemeStyle() -> Int {
        return UserDefaults.standard.integer(forKey: RoutinusRepository.themeStyleKey)
    }

    func updateUsername(of id: String,
                        name: String) {
        RoutinusNetwork.updateUsername(of: id,
                                       name: name,
                                       completion: nil)
    }

    func updateThemeStyle(_ style: Int) {
        UserDefaults.standard.set(style,
                                  forKey: RoutinusRepository.themeStyleKey)
    }
}
