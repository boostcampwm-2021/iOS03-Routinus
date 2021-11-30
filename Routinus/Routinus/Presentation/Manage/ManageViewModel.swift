//
//  ManageViewModel.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/12.
//

import Combine
import Foundation

protocol ManageViewModelInput {
    func fetchMyChallenges()
    func imageData(from directory: String, filename: String, completion: ((Data?) -> Void)?)
    func didTappedAddButton()
    func didTappedChallenge(index: IndexPath)
}

protocol ManageViewModelOutput {
    var participatingChallenges: CurrentValueSubject<[Challenge], Never> { get }
    var createdChallenges: CurrentValueSubject<[Challenge], Never> { get }
    var endedChallenges: CurrentValueSubject<[Challenge], Never> { get }

    var challengeAddButtonTap: PassthroughSubject<Void, Never> { get }
    var challengeTap: PassthroughSubject<String, Never> { get }
}

protocol ManageViewModelIO: ManageViewModelInput, ManageViewModelOutput { }

final class ManageViewModel: ManageViewModelIO {
    private(set) var participatingChallenges = CurrentValueSubject<[Challenge], Never>([])
    private(set) var createdChallenges = CurrentValueSubject<[Challenge], Never>([])
    private(set) var endedChallenges = CurrentValueSubject<[Challenge], Never>([])

    var challengeAddButtonTap = PassthroughSubject<Void, Never>()
    var challengeTap = PassthroughSubject<String, Never>()
    var cancellables = Set<AnyCancellable>()

    let imageFetchUsecase: ImageFetchableUsecase
    let challengeFetchUsecase: ChallengeFetchableUsecase
    let challengeCreatePublisher = NotificationCenter.default.publisher(
        for: ChallengeCreateUsecase.didCreateChallenge,
        object: nil
    )
    let challengeUpdatePublisher = NotificationCenter.default.publisher(
        for: ChallengeUpdateUsecase.didUpdateChallenge,
        object: nil
    )

    init(imageFetchUsecase: ImageFetchableUsecase,
         challengeFetchUsecase: ChallengeFetchableUsecase) {
        self.imageFetchUsecase = imageFetchUsecase
        self.challengeFetchUsecase = challengeFetchUsecase
        self.configurePublishers()
        self.fetchMyChallenges()
    }
}

extension ManageViewModel {
    private func configurePublishers() {
        challengeCreatePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.fetchMyChallenges()
            }
            .store(in: &cancellables)

        challengeUpdatePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.fetchMyChallenges()
            }
            .store(in: &cancellables)
    }

    private func fetchParticipatingChallenges() {
        challengeFetchUsecase.fetchMyParticipatingChallenges { [weak self] challenges in
            self?.participatingChallenges.value = challenges
        }
    }

    private func fetchCreatedChallenges() {
        challengeFetchUsecase.fetchCreatedChallengesByMe { [weak self] challenges in
            self?.createdChallenges.value = challenges
        }
    }

    private func fetchEndedChallenges() {
        challengeFetchUsecase.fetchMyEndedChallenges { [weak self] challenges in
            self?.endedChallenges.value = challenges
        }
    }
}

extension ManageViewModel: ManageViewModelInput {
    func fetchMyChallenges() {
        fetchParticipatingChallenges()
        fetchCreatedChallenges()
        fetchEndedChallenges()
    }

    func imageData(from directory: String,
                   filename: String,
                   completion: ((Data?) -> Void)?) {
        imageFetchUsecase.fetchImageData(from: directory, filename: filename) { data in
            completion?(data)
        }
    }

    func didTappedAddButton() {
        challengeAddButtonTap.send()
    }

    func didTappedChallenge(index: IndexPath) {
        var challengeID: String = ""
        switch index.section {
        case 1:
            challengeID = participatingChallenges.value[index.item].challengeID
        case 2:
            challengeID = createdChallenges.value[index.item].challengeID
        case 3:
            challengeID = endedChallenges.value[index.item].challengeID
        default:
            break
        }
        challengeTap.send(challengeID)
    }
}
