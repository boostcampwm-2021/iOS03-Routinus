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
    func didTappedPopularChallenge(index: Int)
    func didTappedCategoryButton(category: Category)
}

protocol ChallengeViewModelOutput {
    var popularChallenge: CurrentValueSubject<[RecommendChallenge], Never> { get }
    
    var showChallengeSearchSignal: PassthroughSubject<Void, Never> { get }
    var showChallengeDetailSignal: PassthroughSubject<String, Never> { get }
    var showChallengeCategorySignal: PassthroughSubject<Category, Never> { get }
}

protocol ChallengeViewModelIO: ChallengeViewModelInput, ChallengeViewModelOutput { }

class ChallengeViewModel: ChallengeViewModelIO {
    var popularChallenge = CurrentValueSubject<[RecommendChallenge], Never>([])
    
    var showChallengeSearchSignal = PassthroughSubject<Void, Never>()
    var showChallengeDetailSignal = PassthroughSubject<String, Never>()
    var showChallengeCategorySignal = PassthroughSubject<Category, Never>()
    
    init() {
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
    
    func didTappedPopularChallenge(index: Int) {
        let challengeID = self.popularChallenge.value[index].challengeID
        showChallengeDetailSignal.send(challengeID)
    }
    
    func didTappedCategoryButton(category: Category) {
        showChallengeCategorySignal.send(category)
    }
}

extension ChallengeViewModel {
    private func fetchChallenge() {
        
    }
}
