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
    func didLoadedSearchView()
    func imageData(from directory: String, filename: String, completion: ((Data?) -> Void)?)
}

protocol SearchViewModelOutput {
    var challenges: CurrentValueSubject<[Challenge], Never> { get }
    var popularKeywords: CurrentValueSubject<[String], Never> { get }
    var searchKeyword: PassthroughSubject<String, Never> { get }
    var challengeTap: PassthroughSubject<String, Never> { get }
}

protocol SearchViewModelIO: SearchViewModelInput, SearchViewModelOutput { }

final class SearchViewModel: SearchViewModelIO {
    private(set) var challenges = CurrentValueSubject<[Challenge], Never>([])
    private(set) var popularKeywords = CurrentValueSubject<[String], Never>([])
    private(set) var challengeTap = PassthroughSubject<String, Never>()
    private(set) var searchKeyword = PassthroughSubject<String, Never>()

    private var searchCategory: Challenge.Category?
    private var cancellables = Set<AnyCancellable>()

    private let imageFetchUsecase: ImageFetchableUsecase
    private let challengeFetchUsecase: ChallengeFetchableUsecase

    init(category: Challenge.Category? = nil,
         imageFetchUsecase: ImageFetchableUsecase,
         challengeFetchUsecase: ChallengeFetchableUsecase) {
        self.searchCategory = category
        self.imageFetchUsecase = imageFetchUsecase
        self.challengeFetchUsecase = challengeFetchUsecase
        self.fetchPopularKeywords()
        self.bindKeyword()
    }
}

extension SearchViewModel {
     private func bindKeyword() {
         searchKeyword.debounce(for: 0.4, scheduler: RunLoop.main)
             .compactMap { $0 }
             .sink { [weak self] keyword in
                 guard let self = self else { return }
                 if keyword == "" {
                     self.challengeFetchUsecase.fetchLatestChallenges { challenges in
                         self.challenges.value = challenges
                     }
                 } else {
                     self.challengeFetchUsecase.fetchSearchChallenges(keyword: keyword) { challenges in
                         self.challenges.value = challenges
                     }
                 }
             }
             .store(in: &cancellables)
    }

    private func fetchPopularKeywords() {
        let popularKeywords = PopularKeyword.allCases.map { $0.rawValue }
        self.popularKeywords.value = popularKeywords
    }

    private func fetchChallenges() {
        if searchCategory != nil {
            fetchCategoryChallenges()
        } else {
            fetchLatestChallenges()
        }
    }

    private func fetchCategoryChallenges() {
        guard let searchCategory = searchCategory else { return }
        challengeFetchUsecase.fetchSearchChallenges(category: searchCategory) { [weak self] challenge in
            guard let self = self else { return }
            self.challenges.value = challenge
        }
    }

    private func fetchLatestChallenges() {
        challengeFetchUsecase.fetchLatestChallenges { [weak self] challenge in
            guard let self = self else { return }
            self.challenges.value = challenge
        }
    }
}

extension SearchViewModel {
    func didChangedSearchText(_ keyword: String) {
        searchKeyword.send(keyword)
    }

    func didTappedChallenge(index: Int) {
        let challengeID = challenges.value[index].challengeID
        challengeTap.send(challengeID)
    }

    func didLoadedSearchView() {
        fetchChallenges()
    }

    func imageData(from directory: String, filename: String, completion: ((Data?) -> Void)? = nil) {
        imageFetchUsecase.fetchImageData(from: directory, filename: filename) { data in
            completion?(data)
        }
    }
}
