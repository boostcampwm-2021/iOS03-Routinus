//
//  ManageViewModel.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/12.
//

import Combine
import Foundation

protocol ManageViewModelInput {
    func didTappedAddButton()
    func didTappedChallenge(index: Int)
}

protocol ManageViewModelOutput {
    var challenges: CurrentValueSubject<[Challenge], Never> { get }

    var challengeAddButtonTap: PassthroughSubject<Void, Never> { get }
    var challengeTap: PassthroughSubject<String, Never> { get }
}

protocol ManageViewModelIO: ManageViewModelInput, ManageViewModelOutput { }

class ManageViewModel: ManageViewModelIO {
    var challenges = CurrentValueSubject<[Challenge], Never>([])

    var challengeAddButtonTap = PassthroughSubject<Void, Never>()
    var challengeTap = PassthroughSubject<String, Never>()

    let challengeFetchUsecase: ChallengeFetchableUsecase
    var cancellables = Set<AnyCancellable>()

    init(challengeFetchUsecase: ChallengeFetchableUsecase) {
        self.challengeFetchUsecase = challengeFetchUsecase
        self.fetchChallenges()
    }
}

extension ManageViewModel {
    func didTappedAddButton() {
        challengeAddButtonTap.send()
    }

    func didTappedChallenge(index: Int) {
        let challengeID = self.challenges.value[index].challengeID
        challengeTap.send(challengeID)
    }
}

extension ManageViewModel {
    private func fetchChallenges() {
        challengeFetchUsecase.fetchCreationChallengesByMe { [weak self] challenge in
            self?.challenges.value = challenge
        }
    }
}
