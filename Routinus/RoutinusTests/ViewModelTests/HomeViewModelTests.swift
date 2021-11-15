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

    func testFetchUserInfoData() {
        let name = homeViewModel.userInfo.value.name
        let continuityDay = homeViewModel.userInfo.value.continuityDay
        let userImageCategoryID = homeViewModel.userInfo.value.userImageCategoryID
        let grade = homeViewModel.userInfo.value.grade
        XCTAssertEqual(name, "testName")
        XCTAssertEqual(continuityDay, 2)
        XCTAssertEqual(userImageCategoryID, "1")
        XCTAssertEqual(grade, 2)
    }

    func testFetchRoutineData() {
        let chllangeID = homeViewModel.todayRoutine.value.first!.challengeID
        let category = homeViewModel.todayRoutine.value.first!.category
        let title = homeViewModel.todayRoutine.value.first!.title
        let authCount = homeViewModel.todayRoutine.value.first!.authCount
        let totalCount = homeViewModel.todayRoutine.value.first!.totalCount
        XCTAssertEqual(chllangeID, "mockChallengeID")
        XCTAssertEqual(category, .exercise)
        XCTAssertEqual(title, "30분 운동하기")
        XCTAssertEqual(authCount, 2)
        XCTAssertEqual(totalCount, 4)
    }

    func testFetchAchivementData() {
        let yearMonth = homeViewModel.achievementInfo.value.first!.yearMonth
        let day = homeViewModel.achievementInfo.value.first!.day
        let achievementCount = homeViewModel.achievementInfo.value.first!.achievementCount
        let totalCount = homeViewModel.achievementInfo.value.first!.totalCount
        XCTAssertEqual(yearMonth, "202111")
        XCTAssertEqual(day, "06")
        XCTAssertEqual(achievementCount, 1)
        XCTAssertEqual(totalCount, 2)
    }

    func testDidTappedChallengeAddButton() {
        let expectation = expectation(description: "ChallengeShowSignal")

        homeViewModel.showChallengeSignal
            .sink {
                expectation.fulfill()
            }
            .store(in: &cancellables)

        homeViewModel.didTappedAddChallengeButton()
        wait(for: [expectation], timeout: 2)
    }

    func testDidTappedTodayRoutine() {
        let expectation = expectation(description: "ChallengeDetailShowSignal")

        homeViewModel.showChallengeDetailSignal
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
        let expectation = expectation(description: "ChallengeAuthShowSignal")

        homeViewModel.showChallengeAuthSignal
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
