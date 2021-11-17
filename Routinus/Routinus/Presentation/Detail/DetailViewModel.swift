//
//  DetailViewModel.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/17.
//

import Combine
import Foundation

protocol DetailViewModelInput {
    func imageData(from directory: String,
                   filename: String,
                   completion: ((Data?) -> Void)?)
}

protocol DetailViewModelOutput {
    var challenge: PassthroughSubject<Challenge, Never> { get }
}

protocol DetailViewModelIO: DetailViewModelInput, DetailViewModelOutput { }

class DetailViewModel: DetailViewModelIO {

    var challenge = PassthroughSubject<Challenge, Never>()

    let challengeFetchUsecase: ChallengeFetchableUsecase
    let imageFetchUsecase: ImageFetchableUsecase
    var cancellables = Set<AnyCancellable>()
    var challengeID: String?

    init(challengeID: String, challengeFetchUsecase: ChallengeFetchableUsecase, imageFetchUsecase: ImageFetchableUsecase) {
        self.challengeID = challengeID
        self.challengeFetchUsecase = challengeFetchUsecase
        self.imageFetchUsecase = imageFetchUsecase
        self.fetchChallenge()
    }
}

extension DetailViewModel {
}


extension DetailViewModel {
    private func fetchChallenge() {
        guard let challengeID = challengeID else { return }
        challengeFetchUsecase.fetchChallenge(challengeID: challengeID) { [weak self] challenge in
            guard let self = self else { return }
            self.challenge.send(challenge) 
        }
    }

    func imageData(from directory: String,
                   filename: String,
                   completion: ((Data?) -> Void)? = nil) {
        imageFetchUsecase.fetchImageData(from: directory, filename: filename) { data in
            completion?(data)
        }
    }
}
