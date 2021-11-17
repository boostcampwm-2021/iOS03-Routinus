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
    func imageData(from directory: String,
                   filename: String,
                   completion: ((Data?) -> Void)?)
}

protocol SearchViewModelOutput {
    var challenges: CurrentValueSubject<[Challenge], Never> { get }
    var popularKeywords: CurrentValueSubject<[String], Never> { get }

    var challengeTap: PassthroughSubject<String, Never> { get }
}

protocol SearchViewModelIO: SearchViewModelInput, SearchViewModelOutput { }

final class SearchViewModel: SearchViewModelIO {
    var challenges = CurrentValueSubject<[Challenge], Never>([])
    var popularKeywords = CurrentValueSubject<[String], Never>([])

    var challengeTap = PassthroughSubject<String, Never>()

    let imageFetchusecase: ImageFetchableUsecase
    let challengeFetchUsecase: ChallengeFetchableUsecase
    var cancellables = Set<AnyCancellable>()
    var searchKeyword: String?
    var searchCategory: Challenge.Category?

    init(category: Challenge.Category? = nil,
         imageFetchusecase: ImageFetchableUsecase,
         challengeFetchUsecase: ChallengeFetchableUsecase) {
        self.searchCategory = category
        self.imageFetchusecase = imageFetchusecase
        self.challengeFetchUsecase = challengeFetchUsecase
        self.fetchPopularKeywords()
        self.fetchChallenges()
    }
}

extension SearchViewModel {
    func didChangedSearchText(_ keyword: String) {
        if keyword == "" {
            challengeFetchUsecase.fetchLatestChallenges { [weak self] challenges in
                self?.challenges.value = challenges
            }
        } else {
            challengeFetchUsecase.fetchSearchChallenges(keyword: keyword) { [weak self] challenges in
                self?.challenges.value = challenges
            }
        }
    }

    func didTappedChallenge(index: Int) {
        let challengeID = self.challenges.value[index].challengeID
        challengeTap.send(challengeID)
    }

    func imageData(from directory: String,
                   filename: String,
                   completion: ((Data?) -> Void)? = nil) {
        imageFetchusecase.fetchImageData(from: directory, filename: filename) { data in
            completion?(data)
        }
    }
}

extension SearchViewModel {
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

    private func fetchLatestChallenges() {
        challengeFetchUsecase.fetchLatestChallenges { [weak self] challenge in
            self?.challenges.value = challenge
        }
    }

    private func fetchCategoryChallenges() {
        guard let searchCategory = searchCategory else { return }
        challengeFetchUsecase.fetchSearchChallenges(category: searchCategory) { [weak self] challenge in
            self?.challenges.value = challenge
        }
    }
}
