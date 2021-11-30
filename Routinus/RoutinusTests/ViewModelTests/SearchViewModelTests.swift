//
//  SearchViewModelTests.swift
//  RoutinusTests
//
//  Created by 박상우 on 2021/11/30.
//

import Combine
import XCTest
@testable import Routinus

class SearchViewModelTests: XCTestCase {
    var searchViewModel: SearchViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        cancellables = []
    }

    override func tearDown() {
        cancellables.removeAll()
    }

    func testFetchCategoryChallenge() {
        searchViewModel = SearchViewModel(category: .exercise,
                                          imageFetchUsecase: ImageFetchableUsecaseMock(),
                                          challengeFetchUsecase: ChallengeFetchableUsecaseMock())
        guard let challengeID = searchViewModel.challenges.value.first?.challengeID,
              let title = searchViewModel.challenges.value.first?.title,
              let introduction = searchViewModel.challenges.value.first?.introduction,
              let category = searchViewModel.challenges.value.first?.category,
              let imageURL = searchViewModel.challenges.value.first?.imageURL,
              let thumbnailImageURL = searchViewModel.challenges.value.first?.thumbnailImageURL,
              let authExampleImageURL = searchViewModel.challenges.value.first?.authExampleImageURL,
              let authExampleThumbnailImageURL = searchViewModel.challenges.value.first?.authExampleThumbnailImageURL,
              let authMethod = searchViewModel.challenges.value.first?.authMethod,
              let startDate = searchViewModel.challenges.value.first?.startDate,
              let endDate = searchViewModel.challenges.value.first?.endDate,
              let ownerID = searchViewModel.challenges.value.first?.ownerID,
              let week = searchViewModel.challenges.value.first?.week,
              let participantCount = searchViewModel.challenges.value.first?.participantCount else { return }

        XCTAssertEqual(challengeID, "ChallengeID1")
        XCTAssertEqual(title, "categoryTestTitle1")
        XCTAssertEqual(introduction, "categoryIntroduction1")
        XCTAssertEqual(category, .exercise)
        XCTAssertEqual(imageURL, "imageURL1")
        XCTAssertEqual(thumbnailImageURL, "thumbnailImageURL1")
        XCTAssertEqual(authExampleImageURL, "authExampleImageURL1")
        XCTAssertEqual(authExampleThumbnailImageURL, "authExampleThumbnailImageURL1")
        XCTAssertEqual(authMethod, "categoryAuthMethod1")
        XCTAssertEqual(startDate, Date(dateString: "20211130"))
        XCTAssertEqual(endDate, Date(dateString: "20211206"))
        XCTAssertEqual(ownerID, "ownerID1")
        XCTAssertEqual(week, 1)
        XCTAssertEqual(participantCount, 10)
    }

    func testFetchLatestChallenge() {
        searchViewModel = SearchViewModel(category: nil,
                                          imageFetchUsecase: ImageFetchableUsecaseMock(),
                                          challengeFetchUsecase: ChallengeFetchableUsecaseMock())

        guard let challengeID = searchViewModel.challenges.value.first?.challengeID,
              let title = searchViewModel.challenges.value.first?.title,
              let introduction = searchViewModel.challenges.value.first?.introduction,
              let category = searchViewModel.challenges.value.first?.category,
              let imageURL = searchViewModel.challenges.value.first?.imageURL,
              let thumbnailImageURL = searchViewModel.challenges.value.first?.thumbnailImageURL,
              let authExampleImageURL = searchViewModel.challenges.value.first?.authExampleImageURL,
              let authExampleThumbnailImageURL = searchViewModel.challenges.value.first?.authExampleThumbnailImageURL,
              let authMethod = searchViewModel.challenges.value.first?.authMethod,
              let startDate = searchViewModel.challenges.value.first?.startDate,
              let endDate = searchViewModel.challenges.value.first?.endDate,
              let ownerID = searchViewModel.challenges.value.first?.ownerID,
              let week = searchViewModel.challenges.value.first?.week,
              let participantCount = searchViewModel.challenges.value.first?.participantCount else { return }

        XCTAssertEqual(challengeID, "ChallengeID1")
        XCTAssertEqual(title, "latestTestTitle1")
        XCTAssertEqual(introduction, "latestIntroduction1")
        XCTAssertEqual(category, .exercise)
        XCTAssertEqual(imageURL, "imageURL1")
        XCTAssertEqual(thumbnailImageURL, "thumbnailImageURL1")
        XCTAssertEqual(authExampleImageURL, "authExampleImageURL1")
        XCTAssertEqual(authExampleThumbnailImageURL, "authExampleThumbnailImageURL1")
        XCTAssertEqual(authMethod, "latestAuthMethod1")
        XCTAssertEqual(startDate, Date(dateString: "20211130"))
        XCTAssertEqual(endDate, Date(dateString: "20211206"))
        XCTAssertEqual(ownerID, "ownerID1")
        XCTAssertEqual(week, 1)
        XCTAssertEqual(participantCount, 10)
    }

    func testDidTappedChallenge() {
        searchViewModel = SearchViewModel(category: nil,
                                          imageFetchUsecase: ImageFetchableUsecaseMock(),
                                          challengeFetchUsecase: ChallengeFetchableUsecaseMock())

        let expectation = expectation(description: "Show Detail By Tapped Challenge")

        searchViewModel.challengeTap
            .sink { challgenID in
                if challgenID != "" {
                    expectation.fulfill()
                } else {
                    XCTFail("ChallengeID Not Exist")
                }
            }
            .store(in: &cancellables)

        searchViewModel.didTappedChallenge(index: 0)
        wait(for: [expectation], timeout: 2)
    }

    func testDidChangedSearchText() {
        searchViewModel = SearchViewModel(category: nil,
                                          imageFetchUsecase: ImageFetchableUsecaseMock(),
                                          challengeFetchUsecase: ChallengeFetchableUsecaseMock())

        let expectation = expectation(description: "Change SearchBarText By Keyword")

        searchViewModel.searchKeyword
            .sink { keyword in
                if keyword == "test" {
                    expectation.fulfill()
                } else {
                    XCTFail("keyword Not Equal")
                }
            }
            .store(in: &cancellables)

        searchViewModel.didChangedSearchText("test")
        wait(for: [expectation], timeout: 2)
    }
}
