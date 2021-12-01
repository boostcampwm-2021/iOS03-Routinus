//
//  HomeViewModelTests.swift
//  RoutinusTests
//
//  Created by 박상우 on 2021/11/13.
//

import Combine
import XCTest
@testable import Routinus

class HomeViewModelTests: XCTestCase {
    var homeViewModel: HomeViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        homeViewModel = HomeViewModel(userCreateUsecase: UserCreatableUsecaseMock(),
                                      userFetchUsecase: UserFetchableUsecaseMock(),
                                      userUpdateUsecase: UserUpdatableUsecaseMock(),
                                      todayRoutineFetchUsecase: TodayRoutineFetchableUsecaseMock(),
                                      achievementFetchUsecase: AchievementFetchableUsecaseMock(),
                                      authFetchUsecase: AuthFetchableUsecaseMock())
        cancellables = []
    }

    override func tearDown() {
        cancellables.removeAll()
    }

    func testFetchUserData() {
        homeViewModel.fetchMyHomeData()

        let id = homeViewModel.user.value.id
        let name = homeViewModel.user.value.name
        let continuityDay = homeViewModel.user.value.continuityDay
        let userImageCategoryID = homeViewModel.user.value.userImageCategoryID
        let grade = homeViewModel.user.value.grade
        let lastAuthDay = homeViewModel.user.value.lastAuthDay
        XCTAssertEqual(id, "MockUserID")
        XCTAssertEqual(name, "차분한 고양이")
        XCTAssertEqual(continuityDay, 0)
        XCTAssertEqual(userImageCategoryID, "0")
        XCTAssertEqual(grade, 0)
        XCTAssertEqual(lastAuthDay, "20201130")
    }

    func testFetchTodayRoutineData() {
        homeViewModel.fetchMyHomeData()

        guard let chllangeID = homeViewModel.todayRoutines.value.first?.challengeID,
              let category = homeViewModel.todayRoutines.value.first?.category,
              let title = homeViewModel.todayRoutines.value.first?.title,
              let authCount = homeViewModel.todayRoutines.value.first?.authCount,
              let totalCount = homeViewModel.todayRoutines.value.first?.totalCount else { return }
        XCTAssertEqual(chllangeID, "testChallenge1")
        XCTAssertEqual(category, .exercise)
        XCTAssertEqual(title, "테스트 챌린지1")
        XCTAssertEqual(authCount, 0)
        XCTAssertEqual(totalCount, 7)
    }

    func testFetchAchivementData() {
        homeViewModel.fetchMyHomeData()

        let yearMonth = homeViewModel.achievements[0].yearMonth
        let day = homeViewModel.achievements[0].day
        let achievementCount = homeViewModel.achievements[0].achievementCount
        let totalCount = homeViewModel.achievements[0].totalCount
        XCTAssertEqual(yearMonth, "202111")
        XCTAssertEqual(day, "29")
        XCTAssertEqual(achievementCount, 2)
        XCTAssertEqual(totalCount, 4)
    }

    func testFetchThemeStyleData() {
        let themeStyle = homeViewModel.themeStyle()
        XCTAssertEqual(themeStyle, 1)
    }

    func testUpdateDate() {
        homeViewModel.updateDate(month: 0)
        let month = homeViewModel.baseDate.value.month
        XCTAssertEqual(month, 11)
    }

    func testDidTappedChallengeAddButton() {
        let expectation = expectation(description: "Show Challenge By Tapped ChallengeAddButton")

        homeViewModel.challengeAddButtonTap
            .sink {
                expectation.fulfill()
            }
            .store(in: &cancellables)

        homeViewModel.didTappedAddChallengeButton()
        wait(for: [expectation], timeout: 2)
    }

    func testDidTappedTodayRoutine() {
        let expectation = expectation(description: "Show Detail By Tapped TodayRoutine")

        homeViewModel.todayRoutineTap
            .sink { challgenID in
                if challgenID != "" {
                    expectation.fulfill()
                } else {
                    XCTFail("ChallengeID Not Exist")
                }
            }
            .store(in: &cancellables)

        homeViewModel.didTappedTodayRoutine(index: 0)
        wait(for: [expectation], timeout: 2)
    }

    func testDidTappedTodayRoutineAuth() {
        let expectation = expectation(description: "Show Auth By Tapped TodayRoutine")

        homeViewModel.todayRoutineAuthTap
            .sink { challgenID in
                if challgenID != "" {
                    expectation.fulfill()
                } else {
                    XCTFail("ChallengeID Not Exist")
                }
            }
            .store(in: &cancellables)

        homeViewModel.didTappedTodayRoutineAuth(index: 0)
        wait(for: [expectation], timeout: 1)
    }
}
