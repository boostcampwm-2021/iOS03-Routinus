//
//  UserUpdateUsecase.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/21.
//

import Foundation

protocol UserUpdatableUsecase {
    func updateContinuityDay(completion: ((User) -> Void)?)
    func updateContinuityDayByAuth()
    func updateUsername(of id: String, name: String)
    func updateThemeStyle(_ style: Int)
}

struct UserUpdateUsecase: UserUpdatableUsecase {
    static let didUpdateUser = Notification.Name("didUpdateUser")

    var repository: UserRepository

    init(repository: UserRepository) {
        self.repository = repository
    }

    func updateContinuityDay(completion: ((User) -> Void)?) {
        guard let userID = RoutinusRepository.userID() else { return }
        repository.updateContinuityDay(by: userID) { userDTO in
            let user = User(userDTO: userDTO)
            completion?(user)
        }
    }

    func updateContinuityDayByAuth() {
        guard let userID = RoutinusRepository.userID() else { return }
        repository.updateContinuityDayByAuth(by: userID) {
            NotificationCenter.default.post(name: UserUpdateUsecase.didUpdateUser,
                                            object: nil)
        }
    }

    func updateUsername(of id: String, name: String) {
        repository.updateUsername(of: id, name: name) {
            NotificationCenter.default.post(name: UserUpdateUsecase.didUpdateUser,
                                            object: nil)
        }
    }

    func updateThemeStyle(_ style: Int) {
        repository.updateThemeStyle(style)
    }
}
