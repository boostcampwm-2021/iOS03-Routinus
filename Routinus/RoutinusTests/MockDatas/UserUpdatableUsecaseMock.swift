//
//  UserUpdatableUsecaseMock.swift
//  RoutinusTests
//
//  Created by 박상우 on 2021/11/30.
//

import XCTest
@testable import Routinus

class UserUpdatableUsecaseMock: UserUpdatableUsecase {
    func updateContinuityDay(completion: ((User) -> Void)?) {
        let user = User(id: "MockUserID",
                        name: "차분한 고양이",
                        continuityDay: 0,
                        userImageCategoryID: "0",
                        grade: 0,
                        lastAuthDay: "20201130")
        completion?(user)
    }

    func updateContinuityDayByAuth() {
        print("update ContinuityDay!!")
    }

    func updateUsername(of id: String, name: String) {
        print("update id: \(id), userName: \(name)")
    }

    func updateThemeStyle(_ style: Int) {
        print("update ThemeStyle \(style)")
    }
}
