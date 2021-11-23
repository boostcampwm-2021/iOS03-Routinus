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
    func imageData(from directory: String,
                   filename: String,
                   completion: ((Data?) -> Void)?)
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
    let imageFetchUsecase: ImageFetchableUsecase
    var cancellables = Set<AnyCancellable>()

    init(challengeFetchUsecase: ChallengeFetchableUsecase,
         imageFetchUsecase: ImageFetchableUsecase) {
        self.challengeFetchUsecase = challengeFetchUsecase
        self.imageFetchUsecase = imageFetchUsecase
        self.fetchChallenge()
    }
}

extension ChallengeViewModel {
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

    func imageData(from directory: String,
                   filename: String,
                   completion: ((Data?) -> Void)?) {
        imageFetchUsecase.fetchImageData(from: directory,
                                         filename: filename) { data in
            completion?(data)
        }
    }
}

extension ChallengeViewModel {
    func fetchChallenge() {
        challengeFetchUsecase.fetchRecommendChallenges { [weak self] recommendChallenge in
            self?.recommendChallenges.value = recommendChallenge
        }
    }
}
