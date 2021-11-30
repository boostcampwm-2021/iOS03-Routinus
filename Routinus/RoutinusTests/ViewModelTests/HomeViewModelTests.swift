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
        homeViewModel = HomeViewModel(createUsecase: HomeCreatableUsecaseMock(),
                                      fetchUsecase: HomeFetchableUsecaseMock())
        cancellables = []
    }

    override func tearDown() {
        cancellables.removeAll()
    }

    func testFetchUserData() {
        let name = homeViewModel.user.value.name
        let continuityDay = homeViewModel.user.value.continuityDay
        let userImageCategoryID = homeViewModel.user.value.userImageCategoryID
        let grade = homeViewModel.user.value.grade
        XCTAssertEqual(name, "testName")
        XCTAssertEqual(continuityDay, 2)
        XCTAssertEqual(userImageCategoryID, "1")
        XCTAssertEqual(grade, 2)
    }

    func testFetchRoutineData() {
        let chllangeID = homeViewModel.todayRoutines.value.first!.challengeID
        let category = homeViewModel.todayRoutines.value.first!.category
        let title = homeViewModel.todayRoutines.value.first!.title
        let authCount = homeViewModel.todayRoutines.value.first!.authCount
        let totalCount = homeViewModel.todayRoutines.value.first!.totalCount
        XCTAssertEqual(chllangeID, "mockChallengeID")
        XCTAssertEqual(category, .exercise)
        XCTAssertEqual(title, "30분 운동하기")
        XCTAssertEqual(authCount, 2)
        XCTAssertEqual(totalCount, 4)
    }

    func testFetchAchivementData() {
        let yearMonth = homeViewModel.achievement.value.first!.yearMonth
        let day = homeViewModel.achievement.value.first!.day
        let achievementCount = homeViewModel.achievement.value.first!.achievementCount
        let totalCount = homeViewModel.achievement.value.first!.totalCount
        XCTAssertEqual(yearMonth, "202111")
        XCTAssertEqual(day, "06")
        XCTAssertEqual(achievementCount, 1)
        XCTAssertEqual(totalCount, 2)
    }

    func testDidTappedChallengeAddButton() {
        let expectation = expectation(description: "ChallengeShowSignal")

        homeViewModel.challengeAddButtonTap
            .sink {
                expectation.fulfill()
            }
            .store(in: &cancellables)

        homeViewModel.didTappedAddChallengeButton()
        wait(for: [expectation], timeout: 2)
    }

    func testDidTappedTodayRoutine() {
        let expectation = expectation(description: "ChallengeDetailShowSignal")

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
        let expectation = expectation(description: "AuthShowSignal")

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
