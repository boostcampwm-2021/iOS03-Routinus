//
//  ChallengeViewModel.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/08.
//

import Combine
import Foundation

protocol ChallengeViewModelInput {
    func didTappedSearchButton()
    func didTappedSeeAllButton()
    func didTappedRecommendChallenge(index: Int)
    func didTappedCategoryButton(category: Challenge.Category)
}

protocol ChallengeViewModelOutput {
    var recommendChallenges: CurrentValueSubject<[Challenge], Never> { get }

    var searchButtonTap: PassthroughSubject<Void, Never> { get }
    var seeAllButtonTap: PassthroughSubject<Void, Never> { get }
    var recommendChallengeTap: PassthroughSubject<String, Never> { get }
    var categoryButtonTap: PassthroughSubject<Challenge.Category, Never> { get }
}

protocol ChallengeViewModelIO: ChallengeViewModelInput, ChallengeViewModelOutput { }

final class ChallengeViewModel: ChallengeViewModelIO {
    var recommendChallenges = CurrentValueSubject<[Challenge], Never>([])

    var searchButtonTap = PassthroughSubject<Void, Never>()
    var seeAllButtonTap = PassthroughSubject<Void, Never>()
    var recommendChallengeTap = PassthroughSubject<String, Never>()
    var categoryButtonTap = PassthroughSubject<Challenge.Category, Never>()

    let challengeFetchUsecase: ChallengeFetchableUsecase
    var cancellables = Set<AnyCancellable>()

    let challengeCreatePublisher = NotificationCenter.default.publisher(for: ChallengeCreateUsecase.didCreateChallenge,
                                                                        object: nil)

    init(challengeFetchUsecase: ChallengeFetchableUsecase) {
        self.challengeFetchUsecase = challengeFetchUsecase
        self.fetchChallenge()
        self.configurePublishers()
    }
}

extension ChallengeViewModel {
    func configurePublishers() {
        self.challengeCreatePublisher
            .receive(on: RunLoop.main)
            .sink { _ in
                self.fetchChallenge()
            }
            .store(in: &cancellables)
    }

    func didTappedSearchButton() {
        searchButtonTap.send()
    }

    func didTappedSeeAllButton() {
        seeAllButtonTap.send()
    }

    func didTappedRecommendChallenge(index: Int) {
        let challengeID = self.recommendChallenges.value[index].challengeID
        recommendChallengeTap.send(challengeID)
    }

    func didTappedCategoryButton(category: Challenge.Category) {
        categoryButtonTap.send(category)
    }
}

extension ChallengeViewModel {
    func fetchChallenge() {
        challengeFetchUsecase.fetchRecommendChallenges { [weak self] recommendChallenge in
            self?.recommendChallenges.value = recommendChallenge
        }
    }
}
