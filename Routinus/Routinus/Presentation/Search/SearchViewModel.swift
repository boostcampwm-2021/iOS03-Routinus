//
//  SearchViewModel.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/09.
//

import Combine
import Foundation

protocol SearchViewModelInput {
    func didChangedSearchText(_ keyword: String)
    func didTappedChallenge(index: Int)
}

protocol SearchViewModelOutput {
    var challenges: CurrentValueSubject<[Challenge], Never> { get }
    var popularKeywords: CurrentValueSubject<[String], Never> { get }

    var showChallengeDetailSignal: PassthroughSubject<String, Never> { get }
}

protocol SearchViewModelIO: SearchViewModelInput, SearchViewModelOutput { }

final class SearchViewModel: SearchViewModelIO {
    var challenges = CurrentValueSubject<[Challenge], Never>([])
    var popularKeywords = CurrentValueSubject<[String], Never>([])

    var showChallengeDetailSignal = PassthroughSubject<String, Never>()

    let usecase: SearchFetchableUsecase
    var cancellables = Set<AnyCancellable>()
    var searchKeyword: String?
    var searchCategory: Challenge.Category?

    init(category: Challenge.Category? = nil, usecase: SearchFetchableUsecase) {
        self.usecase = usecase
        self.searchCategory = category
        self.fetchPopularKeywords()
        self.fetchChallenges()
    }
}

extension SearchViewModel {
    func didChangedSearchText(_ keyword: String) {
        if keyword == "" {
            usecase.fetchLatestChallenges { [weak self] challenges in
                self?.challenges.value = challenges
            }
        } else {
            usecase.fetchSearchChallenges(keyword: keyword) { [weak self] challenges in
                self?.challenges.value = challenges
            }
        }
    }

    func didTappedChallenge(index: Int) {
        let challengeID = self.challenges.value[index].challengeID
        showChallengeDetailSignal.send(challengeID)
    }
}

extension SearchViewModel {
    private func fetchPopularKeywords() {
        usecase.fetchPopularKeywords { [weak self] keywords in
            self?.popularKeywords.value = keywords
        }
    }

    private func fetchChallenges() {
        if searchCategory != nil {
            fetchCategoryChallenges()
        } else {
            fetchLatestChallenges()
        }
    }

    private func fetchLatestChallenges() {
        usecase.fetchLatestChallenges { [weak self] challenge in
            self?.challenges.value = challenge
        }
    }

    private func fetchCategoryChallenges() {
        guard let searchCategory = searchCategory else { return }
        usecase.fetchSearchChallenges(category: searchCategory) { [weak self] challenge in
            self?.challenges.value = challenge
        }
    }
}
