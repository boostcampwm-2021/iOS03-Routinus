//
//  UserCreatableUsecaseMock.swift
//  RoutinusTests
//
//  Created by 박상우 on 2021/11/30.
//

import XCTest
@testable import Routinus

class UserCreatableUsecaseMock: UserCreatableUsecase {
    func createUser() {
        print("User Create")
    }
}
