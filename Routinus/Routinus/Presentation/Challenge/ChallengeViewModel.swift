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
    var recommendChallenge: CurrentValueSubject<[Challenge], Never> { get }

    var showChallengeSearchSignal: PassthroughSubject<Void, Never> { get }
    var showChallengeDetailSignal: PassthroughSubject<String, Never> { get }
    var showChallengeCategorySignal: PassthroughSubject<Challenge.Category, Never> { get }
}

protocol ChallengeViewModelIO: ChallengeViewModelInput, ChallengeViewModelOutput { }

class ChallengeViewModel: ChallengeViewModelIO {
    var recommendChallenge = CurrentValueSubject<[Challenge], Never>([])

    var showChallengeSearchSignal = PassthroughSubject<Void, Never>()
    var showChallengeDetailSignal = PassthroughSubject<String, Never>()
    var showChallengeCategorySignal = PassthroughSubject<Challenge.Category, Never>()

    let usecase: ChallengeFetchableUsecase
    var cancellables = Set<AnyCancellable>()

    init(usecase: ChallengeFetchableUsecase) {
        self.usecase = usecase
        self.fetchChallenge()
    }
}

extension ChallengeViewModel {
    func didTappedSearchButton() {
        showChallengeSearchSignal.send()
    }

    func didTappedSeeAllButton() {
        showChallengeSearchSignal.send()
    }

    func didTappedRecommendChallenge(index: Int) {
        let challengeID = self.recommendChallenge.value[index].challengeID
        showChallengeDetailSignal.send(challengeID)
    }

    func didTappedCategoryButton(category: Challenge.Category) {
        showChallengeCategorySignal.send(category)
    }
}

extension ChallengeViewModel {
    private func fetchChallenge() {
        usecase.fetchRecommendChallenges { [weak self] recommendChallenge in
            self?.recommendChallenge.value = recommendChallenge
        }
    }
}
