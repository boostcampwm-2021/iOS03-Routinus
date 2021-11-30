//
//  UserRepository.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/17.
//

import Foundation

protocol UserRepository {
    func isEmptyUserID() -> Bool
    func save(id: String, name: String, completion: (() -> Void)?)
    func fetchUser(by id: String, completion: ((User) -> Void)?)
    func updateContinuityDay(by id: String, completion: ((UserDTO) -> Void)?)
    func updateContinuityDayByAuth(by id: String, completion: (() -> Void)?)
    func fetchThemeStyle() -> Int
    func updateUsername(of id: String, name: String, completion: (() -> Void)?)
    func updateThemeStyle(_ style: Int)
}

extension RoutinusRepository: UserRepository {
    func isEmptyUserID() -> Bool {
        return UserDefaults.standard.string(forKey: RoutinusRepository.userIDKey) == nil
    }

    func save(id: String, name: String, completion: (() -> Void)?) {
        UserDefaults.standard.set(id, forKey: RoutinusRepository.userIDKey)
        FirebaseService.insertUser(id: id, name: name) {
            completion?()
        }
    }

    func fetchUser(by id: String, completion: ((User) -> Void)?) {
        FirebaseService.user(of: id) { dto in
            completion?(User(userDTO: dto))
        }
    }

    func updateContinuityDay(by id: String, completion: ((UserDTO) -> Void)?) {
        FirebaseService.updateContinuityDay(of: id) { dto in
            completion?(dto)
        }
    }

    func updateContinuityDayByAuth(by id: String, completion: (() -> Void)?) {
        FirebaseService.updateContinuityDayByAuth(of: id) {
            completion?()
        }
    }

    func fetchThemeStyle() -> Int {
        return UserDefaults.standard.integer(forKey: RoutinusRepository.themeStyleKey)
    }

    func updateUsername(of id: String, name: String, completion: (() -> Void)?) {
        FirebaseService.updateUsername(of: id, name: name) {
            completion?()
        }
    }

    func updateThemeStyle(_ style: Int) {
        UserDefaults.standard.set(style, forKey: RoutinusRepository.themeStyleKey)
    }
}
