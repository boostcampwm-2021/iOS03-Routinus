//
//  SearchViewModel.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/09.
//

import Combine
import Foundation

protocol SearchViewModelInput {
    func didTappedSearchButton(keyword: String)
    func didTappedChallenge(index: Int)
}

protocol SearchViewModelOutput {
    var popularChallenge: CurrentValueSubject<[Challenge], Never> { get }

    var showChallengeSearchSignal: PassthroughSubject<String, Never> { get }
    var showChallengeDetailSignal: PassthroughSubject<String, Never> { get }
    var showChallengeCategorySignal: PassthroughSubject<Category, Never> { get }
}

protocol SearchViewModelIO: SearchViewModelInput, SearchViewModelOutput { }

class SearchViewModel: SearchViewModelIO {
    var popularChallenge = CurrentValueSubject<[Challenge], Never>([])

    var showChallengeSearchSignal = PassthroughSubject<String, Never>()
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
    func didTappedSearchButton(keyword: String) {
        showChallengeSearchSignal.send(keyword)
    }

    func didTappedChallenge(index: Int) {
        let challengeID = self.popularChallenge.value[index].challengeID
        showChallengeDetailSignal.send(challengeID)
    }
}

extension SearchViewModel {
    private func fetchChallenge() {
        usecase.fetchPopularChallenge { [weak self] challenge in
            self?.popularChallenge.value = challenge
        }
    }
}
