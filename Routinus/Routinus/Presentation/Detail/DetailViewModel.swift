//
//  DetailViewModel.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/17.
//

import Combine
import Foundation

protocol DetailViewModelInput {
}

protocol DetailViewModelOutput {
    var challenge: PassthroughSubject<Challenge, Never> { get }
}

protocol DetailViewModelIO: DetailViewModelInput, DetailViewModelOutput { }

class DetailViewModel: DetailViewModelIO {

    var challenge = PassthroughSubject<Challenge, Never>()

    let challengeFetchUsecase: ChallengeFetchableUsecase
    var cancellables = Set<AnyCancellable>()
    var challengeID: String?

    init(challengeID: String, challengeFetchUsecase: ChallengeFetchableUsecase) {
        self.challengeID = challengeID
        self.challengeFetchUsecase = challengeFetchUsecase
        self.fetchChallenge()
    }
}

extension DetailViewModel {
}


extension DetailViewModel {
    private func fetchChallenge() {
        guard let challengeID = challengeID else { return }
        challengeFetchUsecase.fetchChallenge(challengeID: challengeID) { [weak self] challenge in
            guard let self = self, let challenge = challenge else { return }
            self.challenge.send(challenge) 
        }
    }
}
