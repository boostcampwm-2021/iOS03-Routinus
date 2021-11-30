//
//  ManageViewModelTests.swift
//  RoutinusTests
//
//  Created by 박상우 on 2021/12/01.
//

import Combine
import XCTest
@testable import Routinus

class ManageViewModelTests: XCTestCase {
    var manageViewModel: ManageViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        manageViewModel = ManageViewModel(imageFetchUsecase: ImageFetchableUsecaseMock(),
                                          challengeFetchUsecase: ChallengeFetchableUsecaseMock())
        cancellables = []
    }

    override func tearDown() {
        cancellables.removeAll()
    }

    func testFetchParticipatingChallenges() {
        manageViewModel.fetchMyChallenges()

        guard let challengeID = manageViewModel.participatingChallenges.value.first?.challengeID,
              let title = manageViewModel.participatingChallenges.value.first?.title,
              let introduction = manageViewModel.participatingChallenges.value.first?.introduction,
              let category = manageViewModel.participatingChallenges.value.first?.category,
              let imageURL = manageViewModel.participatingChallenges.value.first?.imageURL,
              let thumbnailImageURL = manageViewModel.participatingChallenges.value.first?.thumbnailImageURL,
              let authExampleImageURL = manageViewModel.participatingChallenges.value.first?.authExampleImageURL,
              let authExampleThumbnailImageURL = manageViewModel.participatingChallenges.value.first?.authExampleThumbnailImageURL,
              let authMethod = manageViewModel.participatingChallenges.value.first?.authMethod,
              let startDate = manageViewModel.participatingChallenges.value.first?.startDate,
              let endDate = manageViewModel.participatingChallenges.value.first?.endDate,
              let ownerID = manageViewModel.participatingChallenges.value.first?.ownerID,
              let week = manageViewModel.participatingChallenges.value.first?.week,
              let participantCount = manageViewModel.participatingChallenges.value.first?.participantCount else { return }

        XCTAssertEqual(challengeID, "ChallengeID1")
        XCTAssertEqual(title, "TestTitle1")
        XCTAssertEqual(introduction, "introduction1")
        XCTAssertEqual(category, .exercise)
        XCTAssertEqual(imageURL, "imageURL1")
        XCTAssertEqual(thumbnailImageURL, "thumbnailImageURL1")
        XCTAssertEqual(authExampleImageURL, "authExampleImageURL1")
        XCTAssertEqual(authExampleThumbnailImageURL, "authExampleThumbnailImageURL1")
        XCTAssertEqual(authMethod, "authMethod1")
        XCTAssertEqual(startDate, Date(dateString: "20211130"))
        XCTAssertEqual(endDate, Date(dateString: "20211206"))
        XCTAssertEqual(ownerID, "ownerID1")
        XCTAssertEqual(week, 1)
        XCTAssertEqual(participantCount, 10)
    }

    func testFetchCreatedChallenges() {
        manageViewModel.fetchMyChallenges()

        guard let challengeID = manageViewModel.participatingChallenges.value.first?.challengeID,
              let title = manageViewModel.participatingChallenges.value.first?.title,
              let introduction = manageViewModel.participatingChallenges.value.first?.introduction,
              let category = manageViewModel.participatingChallenges.value.first?.category,
              let imageURL = manageViewModel.participatingChallenges.value.first?.imageURL,
              let thumbnailImageURL = manageViewModel.participatingChallenges.value.first?.thumbnailImageURL,
              let authExampleImageURL = manageViewModel.participatingChallenges.value.first?.authExampleImageURL,
              let authExampleThumbnailImageURL = manageViewModel.participatingChallenges.value.first?.authExampleThumbnailImageURL,
              let authMethod = manageViewModel.participatingChallenges.value.first?.authMethod,
              let startDate = manageViewModel.participatingChallenges.value.first?.startDate,
              let endDate = manageViewModel.participatingChallenges.value.first?.endDate,
              let ownerID = manageViewModel.participatingChallenges.value.first?.ownerID,
              let week = manageViewModel.participatingChallenges.value.first?.week,
              let participantCount = manageViewModel.participatingChallenges.value.first?.participantCount else { return }

        XCTAssertEqual(challengeID, "ChallengeID1")
        XCTAssertEqual(title, "TestTitle1")
        XCTAssertEqual(introduction, "introduction1")
        XCTAssertEqual(category, .exercise)
        XCTAssertEqual(imageURL, "imageURL1")
        XCTAssertEqual(thumbnailImageURL, "thumbnailImageURL1")
        XCTAssertEqual(authExampleImageURL, "authExampleImageURL1")
        XCTAssertEqual(authExampleThumbnailImageURL, "authExampleThumbnailImageURL1")
        XCTAssertEqual(authMethod, "authMethod1")
        XCTAssertEqual(startDate, Date(dateString: "20211130"))
        XCTAssertEqual(endDate, Date(dateString: "20211206"))
        XCTAssertEqual(ownerID, "ownerID1")
        XCTAssertEqual(week, 1)
        XCTAssertEqual(participantCount, 10)
    }

    func testFetchEndedChallenges() {
        manageViewModel.fetchMyChallenges()

        guard let challengeID = manageViewModel.participatingChallenges.value.first?.challengeID,
              let title = manageViewModel.participatingChallenges.value.first?.title,
              let introduction = manageViewModel.participatingChallenges.value.first?.introduction,
              let category = manageViewModel.participatingChallenges.value.first?.category,
              let imageURL = manageViewModel.participatingChallenges.value.first?.imageURL,
              let thumbnailImageURL = manageViewModel.participatingChallenges.value.first?.thumbnailImageURL,
              let authExampleImageURL = manageViewModel.participatingChallenges.value.first?.authExampleImageURL,
              let authExampleThumbnailImageURL = manageViewModel.participatingChallenges.value.first?.authExampleThumbnailImageURL,
              let authMethod = manageViewModel.participatingChallenges.value.first?.authMethod,
              let startDate = manageViewModel.participatingChallenges.value.first?.startDate,
              let endDate = manageViewModel.participatingChallenges.value.first?.endDate,
              let ownerID = manageViewModel.participatingChallenges.value.first?.ownerID,
              let week = manageViewModel.participatingChallenges.value.first?.week,
              let participantCount = manageViewModel.participatingChallenges.value.first?.participantCount else { return }

        XCTAssertEqual(challengeID, "ChallengeID1")
        XCTAssertEqual(title, "TestTitle1")
        XCTAssertEqual(introduction, "introduction1")
        XCTAssertEqual(category, .exercise)
        XCTAssertEqual(imageURL, "imageURL1")
        XCTAssertEqual(thumbnailImageURL, "thumbnailImageURL1")
        XCTAssertEqual(authExampleImageURL, "authExampleImageURL1")
        XCTAssertEqual(authExampleThumbnailImageURL, "authExampleThumbnailImageURL1")
        XCTAssertEqual(authMethod, "authMethod1")
        XCTAssertEqual(startDate, Date(dateString: "20211130"))
        XCTAssertEqual(endDate, Date(dateString: "20211206"))
        XCTAssertEqual(ownerID, "ownerID1")
        XCTAssertEqual(week, 1)
        XCTAssertEqual(participantCount, 10)
    }

    func testDidTappedChallenge() {
        let expectation = expectation(description: "Show Detail By Tapped Challenge")

        manageViewModel.challengeTap
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)

        manageViewModel.didTappedChallenge(index: IndexPath(index: 0))
        wait(for: [expectation], timeout: 2)
    }

    func testDidTappedAddButton() {
        let expectation = expectation(description: "Show Form By Tapped challengeAddButton")

        manageViewModel.challengeAddButtonTap
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)

        manageViewModel.didTappedAddButton()
        wait(for: [expectation], timeout: 2)
    }
}
