//
//  DetailViewModelTests.swift
//  RoutinusTests
//
//  Created by 박상우 on 2021/11/30.
//

import Combine
import XCTest
@testable import Routinus

class DetailViewModelTests: XCTestCase {
    var detailViewModel: DetailViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        detailViewModel = DetailViewModel(challengeID: "ChallengeID1",
                                          challengeFetchUsecase: ChallengeFetchableUsecaseMock(),
                                          challengeUpdateUsecase: ChallengeUpdatableUsecaseMock(),
                                          imageFetchUsecase: ImageFetchableUsecaseMock(),
                                          participationFetchUsecase: ParticipationFetchableUsecaseNilMock(),
                                          participationCreateUsecase: ParticipationCreatableUsecaseMock(),
                                          userFetchUsecase: UserFetchableUsecaseMock(),
                                          authFetchUsecase: AuthFetchableUsecaseMock(),
                                          achievementUpdateUsecase: AchievementUpdatableUsecaseMock())
        cancellables = []
    }

    override func tearDown() {
        cancellables.removeAll()
    }

    func testFetchChallenge() {
        let expectation = expectation(description: "Fetch Detail Challenge")

        detailViewModel.challenge
            .receive(on: RunLoop.main)
            .sink { challenge in
                XCTAssertEqual(challenge.challengeID, "ChallengeID1")
                XCTAssertEqual(challenge.title, "TestTitle1")
                XCTAssertEqual(challenge.introduction, "introduction1")
                XCTAssertEqual(challenge.category, .exercise)
                XCTAssertEqual(challenge.imageURL, "imageURL1")
                XCTAssertEqual(challenge.thumbnailImageURL, "thumbnailImageURL1")
                XCTAssertEqual(challenge.authExampleImageURL, "authExampleImageURL1")
                XCTAssertEqual(challenge.authExampleThumbnailImageURL, "authExampleThumbnailImageURL1")
                XCTAssertEqual(challenge.authMethod, "authMethod1")
                XCTAssertEqual(challenge.startDate?.toDateString(), "20211120")
                XCTAssertEqual(challenge.endDate?.toDateString(), "20211126")
                XCTAssertEqual(challenge.ownerID, "ownerID1")
                XCTAssertEqual(challenge.week, 1)
                XCTAssertEqual(challenge.participantCount, 10)
            expectation.fulfill()
        }.store(in: &cancellables)

        detailViewModel.fetchChallenge()
        wait(for: [expectation], timeout: 2)
    }

    func testDidTappedAuthButton() {
        let expectation = expectation(description: "Tapped Auth Button")

        detailViewModel.participationButtonTap
            .sink { _ in
                expectation.fulfill()
            }
            .store(in: &cancellables)

        detailViewModel.didTappedParticipationAuthButton()
        wait(for: [expectation], timeout: 2)
    }
}
