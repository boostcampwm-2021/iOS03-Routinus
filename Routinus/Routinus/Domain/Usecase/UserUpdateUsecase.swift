//
//  UserUpdateUsecase.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/21.
//

import Foundation

protocol UserUpdatableUsecase {
    func updateContinuityDayByAuth()
    func updateUsername(of id: String, name: String)
    func updateThemeStyle(_ style: Int)
}

struct UserUpdateUsecase: UserUpdatableUsecase {
    var repository: UserRepository

    init(repository: UserRepository) {
        self.repository = repository
    }

    func updateContinuityDayByAuth() {
        guard let userID = RoutinusRepository.userID() else { return }
        self.repository.updateContinuityDayByAuth(by: userID)
    }

    func updateUsername(of id: String,
                        name: String) {
        self.repository.updateUsername(of: id,
                                       name: name)
    }

    func updateThemeStyle(_ style: Int) {
        self.repository.updateThemeStyle(style)
    }
}
