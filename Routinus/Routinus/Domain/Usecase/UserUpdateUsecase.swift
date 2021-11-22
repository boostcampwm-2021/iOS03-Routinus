//
//  UserUpdateUsecase.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/21.
//

import Foundation

protocol UserUpdatableUsecase {
    func updateContinuityDay()
    func updateThemeStyle(_ style: Int)
}

struct UserUpdateUsecase: UserUpdatableUsecase {
    var repository: UserRepository

    init(repository: UserRepository) {
        self.repository = repository
    }

    func updateContinuityDay() {
        guard let userID = RoutinusRepository.userID() else { return }
        self.repository.updateContinuityDay(by: userID)
    }

    func updateThemeStyle(_ style: Int) {
        self.repository.updateThemeStyle(style)
    }
}
