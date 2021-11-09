//
//  SearchViewModel.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/09.
//

import Combine
import Foundation

protocol SearchViewModelInput {
    func didTappedSearchButton()
    func didTappedRecommendChallenge(index: Int)
}

protocol SearchViewModelOutput {
    var popularChallenge: CurrentValueSubject<[Challenge], Never> { get }

    var showChallengeSearchSignal: PassthroughSubject<Void, Never> { get }
    var showChallengeDetailSignal: PassthroughSubject<String, Never> { get }
    var showChallengeCategorySignal: PassthroughSubject<Category, Never> { get }
}

protocol SearchViewModelIO: SearchViewModelInput, SearchViewModelOutput { }

class SearchViewModel: SearchViewModelIO {
    var popularChallenge = CurrentValueSubject<[Challenge], Never>([])

    var showChallengeSearchSignal = PassthroughSubject<Void, Never>()
    var showChallengeDetailSignal = PassthroughSubject<String, Never>()
    var showChallengeCategorySignal = PassthroughSubject<Category, Never>()

    let usecase: SearchFetchableUsecase
    var cancellables = Set<AnyCancellable>()

    init(usecase: SearchFetchableUsecase) {
        self.usecase = usecase
        self.fetchChallenge()
    }
}

extension SearchViewModel {
    func didTappedSearchButton() {
        showChallengeSearchSignal.send()
    }

    func didTappedRecommendChallenge(index: Int) {
        let challengeID = self.popularChallenge.value[index].challengeID
        showChallengeDetailSignal.send(challengeID)
    }
}

extension SearchViewModel {
    private func fetchChallenge() {
        usecase.fetchPopularChallenge { [weak self] recommendChallenge in
            self?.popularChallenge.value = recommendChallenge
        }
    }
}
