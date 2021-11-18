//
//  DetailViewModel.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/17.
//

import Combine
import Foundation

enum ParticipationAuthState: String {
    case notParticipating = "참여하기"
    case notAuthenticating = "인증하기"
    case authenticated = "인증완료"
}

protocol DetailViewModelInput {
    func imageData(from directory: String,
                   filename: String,
                   completion: ((Data?) -> Void)?)
    func didTappedEditBarButton()
    func didTappedParticipationButton()
}

protocol DetailViewModelOutput {
    var ownerState: CurrentValueSubject<Bool, Never> { get }
    var participationAuthState: CurrentValueSubject<ParticipationAuthState, Never> { get }

    var challenge: PassthroughSubject<Challenge, Never> { get }
    var editBarButtonTap: PassthroughSubject<String, Never> { get }
    var participationButtonTap: PassthroughSubject<Void, Never> { get }
}

protocol DetailViewModelIO: DetailViewModelInput, DetailViewModelOutput { }

class DetailViewModel: DetailViewModelIO {
    var ownerState = CurrentValueSubject<Bool, Never>(false)
    var participationAuthState = CurrentValueSubject<ParticipationAuthState, Never>(.notParticipating)

    var challenge = PassthroughSubject<Challenge, Never>()
    var editBarButtonTap = PassthroughSubject<String, Never>()
    var participationButtonTap = PassthroughSubject<Void, Never>()

    let challengeFetchUsecase: ChallengeFetchableUsecase
    let imageFetchUsecase: ImageFetchableUsecase
    let participationFetchUsecase: ParticipationFetchableUsecase
    let participationCreateUsecase: ParticipationCreatableUsecase
    let userFetchUsecase: UserFetchableUsecase
    let challengeAuthFetchUsecase: ChallengeAuthFetchableUsecase
    var cancellables = Set<AnyCancellable>()
    var challengeID: String?

    init(challengeID: String,
         challengeFetchUsecase: ChallengeFetchableUsecase,
         imageFetchUsecase: ImageFetchableUsecase,
         participationFetchUsecase: ParticipationFetchableUsecase,
         participationCreateUsecase: ParticipationCreatableUsecase,
         userFetchUsecase: UserFetchableUsecase,
         challengeAuthFetchUsecase: ChallengeAuthFetchUsecase) {
        self.challengeID = challengeID
        self.challengeFetchUsecase = challengeFetchUsecase
        self.imageFetchUsecase = imageFetchUsecase
        self.participationFetchUsecase = participationFetchUsecase
        self.participationCreateUsecase = participationCreateUsecase
        self.userFetchUsecase = userFetchUsecase
        self.challengeAuthFetchUsecase = challengeAuthFetchUsecase
        self.fetchChallenge()
        self.updateParticipationAuthState()
    }
}

extension DetailViewModel {
    func didTappedEditBarButton() {
        guard let challengeID = challengeID else { return }
        self.editBarButtonTap.send(challengeID)
    }

    func didTappedParticipationButton() {
        if participationAuthState.value == .notParticipating {
            guard let challengeID = challengeID else { return }
            participationCreateUsecase.createParticipation(challengeID: challengeID)
            self.participationAuthState.value = .notAuthenticating
        }
    }
}

extension DetailViewModel {
    private func fetchChallenge() {
        guard let challengeID = challengeID else { return }
        challengeFetchUsecase.fetchChallenge(challengeID: challengeID) { [weak self] challenge in
            guard let self = self else { return }
            self.ownerState.value = self.isChallengeOwner(challenge: challenge)
            self.challenge.send(challenge)
        }
    }

    private func fetchParticipation(completion: @escaping (Participation?) -> Void) {
        guard let challengeID = challengeID else { return }
        participationFetchUsecase.fetchParticipation(challengeID: challengeID) { [weak self] participation in
            guard let self = self else { return }
            completion(participation)
        }
    }

    private func fetchAuth(completion: @escaping (ChallengeAuth?) -> Void) {
        guard let challengeID = challengeID else { return }
        challengeAuthFetchUsecase.fetchChallengeAuth(challengeID: challengeID) { [weak self] challengeAuth in
            guard let self = self else { return }
            completion(challengeAuth)
        }
    }

    private func updateParticipationAuthState() {
        fetchParticipation { [weak self] participation in
            guard let self = self else { return }
            if participation == nil {
                self.participationAuthState.value = .notParticipating
            } else {
                self.fetchAuth { [weak self] challengeAuth in
                    guard let self = self else { return }
                    self.participationAuthState.value = challengeAuth == nil ? .notAuthenticating : .authenticated
                }
            }
        }
    }

    private func isChallengeOwner(challenge: Challenge) -> Bool {
        return challenge.ownerID == userFetchUsecase.fetchUserID()
    }

    func imageData(from directory: String,
                   filename: String,
                   completion: ((Data?) -> Void)? = nil) {
        imageFetchUsecase.fetchImageData(from: directory, filename: filename) { data in
            completion?(data)
        }
    }
}
