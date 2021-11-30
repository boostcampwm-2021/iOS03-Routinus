//
//  UserFetchableUsecaseMock.swift
//  RoutinusTests
//
//  Created by 박상우 on 2021/11/30.
//

import XCTest
@testable import Routinus

class UserFetchableUsecaseMock: UserFetchableUsecase {
    func fetchUser(id: String, completion: @escaping (User) -> Void) {
        let user = User(id: "MockUserID",
                        name: "차분한 고양이",
                        continuityDay: 0,
                        userImageCategoryID: "0",
                        grade: 0,
                        lastAuthDay: "2020")
        completion(user)
    }
    
    func fetchUserID() -> String? {
        return "MockUserID"
    }
    
    func fetchThemeStyle() -> Int {
        return 1
    }
}
