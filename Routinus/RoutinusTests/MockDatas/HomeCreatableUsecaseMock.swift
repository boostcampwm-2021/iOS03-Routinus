//
//  HomeCreatableUsecaseMock.swift
//  RoutinusTests
//
//  Created by 박상우 on 2021/11/13.
//

import XCTest
@testable import Routinus

class HomeCreatableUsecaseMock: HomeCreatableUsecase {
    init () {}

    func createUserID() {
        print("createUseID")
    }
}
