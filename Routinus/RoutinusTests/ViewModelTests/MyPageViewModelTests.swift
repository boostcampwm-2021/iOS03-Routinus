//
//  MyPageViewModelTests.swift
//  RoutinusTests
//
//  Created by 박상우 on 2021/12/01.
//

import Combine
import XCTest
@testable import Routinus

class MyPageViewModelTests: XCTestCase {
    var myPageViewModel: MyPageViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        myPageViewModel = MyPageViewModel(userFetchUsecase: UserFetchableUsecaseMock(),
                                          userUpdateUsecase: UserUpdatableUsecaseMock())
        cancellables = []
    }

    override func tearDown() {
        cancellables.removeAll()
    }

    func testFetchUser() {
        myPageViewModel.fetchUser()

        let id = myPageViewModel.user.value.id
        let name = myPageViewModel.user.value.name
        let continuityDay = myPageViewModel.user.value.continuityDay
        let userImageCategoryID = myPageViewModel.user.value.userImageCategoryID
        let grade = myPageViewModel.user.value.grade
        let lastAuthDay = myPageViewModel.user.value.lastAuthDay

        XCTAssertEqual(id, "MockUserID")
        XCTAssertEqual(name, "차분한 고양이")
        XCTAssertEqual(continuityDay, 0)
        XCTAssertEqual(userImageCategoryID, "0")
        XCTAssertEqual(grade, 0)
        XCTAssertEqual(lastAuthDay, "20201130")
    }

    func testFetchThemeStyle() {
        myPageViewModel.fetchThemeStyle()
        let themeStyle = myPageViewModel.themeStyle.value
        XCTAssertEqual(themeStyle, 1)
    }
}
