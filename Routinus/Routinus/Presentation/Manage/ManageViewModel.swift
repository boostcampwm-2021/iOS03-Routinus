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
    func didLoadedManageView()
    func imageData(from directory: String,
                   filename: String,
                   completion: ((Data?) -> Void)?)
}

protocol ManageViewModelOutput {
    var createdChallenges: CurrentValueSubject<[Challenge], Never> { get }
    var participatedChallenges: CurrentValueSubject<[Challenge], Never> { get }

    var challengeAddButtonTap: PassthroughSubject<Void, Never> { get }
    var challengeTap: PassthroughSubject<String, Never> { get }
}

protocol ManageViewModelIO: ManageViewModelInput, ManageViewModelOutput { }

class ManageViewModel: ManageViewModelIO {
    var createdChallenges = CurrentValueSubject<[Challenge], Never>([])
    var participatedChallenges = CurrentValueSubject<[Challenge], Never>([])

    var challengeAddButtonTap = PassthroughSubject<Void, Never>()
    var challengeTap = PassthroughSubject<String, Never>()

    let imageFetchUsecase: ImageFetchableUsecase
    let challengeFetchUsecase: ChallengeFetchableUsecase
    var cancellables = Set<AnyCancellable>()

    init(imageFetchUsecase: ImageFetchableUsecase,
         challengeFetchUsecase: ChallengeFetchableUsecase) {
        self.imageFetchUsecase = imageFetchUsecase
        self.challengeFetchUsecase = challengeFetchUsecase
    }
}

extension ManageViewModel {
    func didTappedAddButton() {
        challengeAddButtonTap.send()
    }

    func didTappedChallenge(index: Int) {
        let challengeID = self.createdChallenges.value[index].challengeID
        challengeTap.send(challengeID)
    }

    func didLoadedManageView() {
        fetchChallenges()
        fetchParticipatedChallenges()
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

extension ManageViewModel {
    private func fetchChallenges() {
        challengeFetchUsecase.fetchCreationChallengesByMe { [weak self] challenges in
            self?.createdChallenges.value = challenges
        }
    }

    private func fetchParticipatedChallenges() {
        challengeFetchUsecase.fetchParticipatedChallenges { [weak self] challenges in
            self?.participatedChallenges.value = challenges
        }
    }
}
