//
//  ChallengeViewModelTests.swift
//  RoutinusTests
//
//  Created by 박상우 on 2021/11/30.
//

import Combine
import XCTest
@testable import Routinus

class ChallengeViewModelTests: XCTestCase {
    var challengeViewModel: ChallengeViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        challengeViewModel = ChallengeViewModel(challengeFetchUsecase: ChallengeFetchableUsecaseMock())
        cancellables = []
    }

    override func tearDown() {
        cancellables.removeAll()
    }
    
    func testFetchRecommendChallenges() {
        challengeViewModel.fetchChallenge()
        guard let challengeID = challengeViewModel.recommendChallenges.value.first?.challengeID,
              let title = challengeViewModel.recommendChallenges.value.first?.title,
              let introduction = challengeViewModel.recommendChallenges.value.first?.introduction,
              let category = challengeViewModel.recommendChallenges.value.first?.category,
              let imageURL = challengeViewModel.recommendChallenges.value.first?.imageURL,
              let thumbnailImageURL = challengeViewModel.recommendChallenges.value.first?.thumbnailImageURL,
              let authExampleImageURL = challengeViewModel.recommendChallenges.value.first?.authExampleImageURL,
              let authExampleThumbnailImageURL = challengeViewModel.recommendChallenges.value.first?.authExampleThumbnailImageURL,
              let authMethod = challengeViewModel.recommendChallenges.value.first?.authMethod,
              let startDate = challengeViewModel.recommendChallenges.value.first?.startDate,
              let endDate = challengeViewModel.recommendChallenges.value.first?.endDate,
              let ownerID = challengeViewModel.recommendChallenges.value.first?.ownerID,
              let week = challengeViewModel.recommendChallenges.value.first?.week,
              let participantCount = challengeViewModel.recommendChallenges.value.first?.participantCount else { return }
        
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
    
    func testDidTappedSearchButton() {
        let expectation = expectation(description: "Show Search By Tapped SearchButton")

        challengeViewModel.searchButtonTap
            .sink {
                expectation.fulfill()
            }
            .store(in: &cancellables)

        challengeViewModel.didTappedSearchButton()
        wait(for: [expectation], timeout: 2)
    }

    func testDidTappedSeeAllButton() {
        let expectation = expectation(description: "Show Search By Tapped SeeAllButton")

        challengeViewModel.seeAllButtonTap
            .sink {
                expectation.fulfill()
            }
            .store(in: &cancellables)

        challengeViewModel.didTappedSeeAllButton()
        wait(for: [expectation], timeout: 2)
    }

    func testDidTappedRecommendChallenge() {
        let expectation = expectation(description: "Show Detail By Tapped RecommendChallenge")

        challengeViewModel.recommendChallengeTap
            .sink { challgenID in
                if challgenID != "" {
                    expectation.fulfill()
                } else {
                    XCTFail("ChallengeID Not Exist")
                }
            }
            .store(in: &cancellables)

        challengeViewModel.didTappedRecommendChallenge(index: 0)
        wait(for: [expectation], timeout: 2)
    }

    func testDidTappedCategoryButton() {
        let expectation = expectation(description: "Show Category Search By Tapped CategoryButton")

        challengeViewModel.categoryButtonTap
            .sink { category in
                if category != .exercise {
                    XCTFail("Category Not Equal")
                } else {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        challengeViewModel.didTappedCategoryButton(category: .exercise)
        wait(for: [expectation], timeout: 2)
    }
}
