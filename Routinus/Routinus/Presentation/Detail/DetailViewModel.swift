//
//  DetailViewModel.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/17.
//

import Combine
import Foundation

enum ParticipationAuthState: String {
    case notParticipating = "participate"
    case notAuthenticating = "certify"
    case authenticated = "certified"
}

protocol DetailViewModelInput {
    func fetchChallenge()
    func imageData(from directory: String,
                   filename: String,
                   completion: ((Data?) -> Void)?)
    func didTappedEditBarButton()
    func didTappedParticipationAuthButton()
    func didTappedAlertConfirm()
    func didTappedAllAuthDisplayView()
    func didTappedMyAuthDisplayView() 
    func didTappedAuthMethodImage(imageData: Data)
    func loadAuthMethodImage(imageData: Data)
    func updateParticipantCount()
}

protocol DetailViewModelOutput {
    var ownerState: CurrentValueSubject<Bool, Never> { get }
    var participationAuthState: CurrentValueSubject<ParticipationAuthState, Never> { get }

    var challenge: PassthroughSubject<Challenge, Never> { get }
    var editBarButtonTap: PassthroughSubject<String, Never> { get }
    var participationButtonTap: PassthroughSubject<Void, Never> { get }
    var authButtonTap: PassthroughSubject<String, Never> { get }
    var alertConfirmTap: PassthroughSubject<Void, Never> { get }
    var allAuthDisplayViewTap: PassthroughSubject<String, Never> { get }
    var myAuthDisplayViewTap: PassthroughSubject<String, Never> { get }
    var authMethodImageTap: PassthroughSubject<Data, Never> { get }
    var authMethodImageLoad: PassthroughSubject<Data, Never> { get }
    var challengeID: String? { get }
}

protocol DetailViewModelIO: DetailViewModelInput, DetailViewModelOutput { }

class DetailViewModel: DetailViewModelIO {
    var ownerState = CurrentValueSubject<Bool, Never>(false)
    var participationAuthState = CurrentValueSubject<ParticipationAuthState, Never>(.notParticipating)

    var challenge = PassthroughSubject<Challenge, Never>()
    var editBarButtonTap = PassthroughSubject<String, Never>()
    var participationButtonTap = PassthroughSubject<Void, Never>()
    var authButtonTap = PassthroughSubject<String, Never>()
    var alertConfirmTap = PassthroughSubject<Void, Never>()
    var allAuthDisplayViewTap = PassthroughSubject<String, Never>()
    var myAuthDisplayViewTap = PassthroughSubject<String, Never>()
    var authMethodImageTap = PassthroughSubject<Data, Never>()
    var authMethodImageLoad = PassthroughSubject<Data, Never>()

    let challengeFetchUsecase: ChallengeFetchableUsecase
    let challengeUpdateUsecase: ChallengeUpdatableUsecase
    let imageFetchUsecase: ImageFetchableUsecase
    let participationFetchUsecase: ParticipationFetchableUsecase
    let participationCreateUsecase: ParticipationCreatableUsecase
    let userFetchUsecase: UserFetchableUsecase
    let challengeAuthFetchUsecase: ChallengeAuthFetchableUsecase
    let achievementUpdateUsecase: AchievementUpdatableUsecase
    var cancellables = Set<AnyCancellable>()
    private(set) var challengeID: String?

    init(challengeID: String,
         challengeFetchUsecase: ChallengeFetchableUsecase,
         challengeUpdateUsecase: ChallengeUpdatableUsecase,
         imageFetchUsecase: ImageFetchableUsecase,
         participationFetchUsecase: ParticipationFetchableUsecase,
         participationCreateUsecase: ParticipationCreatableUsecase,
         userFetchUsecase: UserFetchableUsecase,
         challengeAuthFetchUsecase: ChallengeAuthFetchUsecase,
         achievementUpdateUsecase: AchievementUpdateUsecase) {
        self.challengeID = challengeID
        self.challengeFetchUsecase = challengeFetchUsecase
        self.challengeUpdateUsecase = challengeUpdateUsecase
        self.imageFetchUsecase = imageFetchUsecase
        self.participationFetchUsecase = participationFetchUsecase
        self.participationCreateUsecase = participationCreateUsecase
        self.userFetchUsecase = userFetchUsecase
        self.challengeAuthFetchUsecase = challengeAuthFetchUsecase
        self.achievementUpdateUsecase = achievementUpdateUsecase
        self.fetchChallenge()
        self.updateParticipationAuthState()
    }
}

extension DetailViewModel {
    func fetchChallenge() {
        guard let challengeID = challengeID else { return }
        challengeFetchUsecase.fetchChallenge(challengeID: challengeID) { [weak self] challenge in
            guard let self = self else { return }
            self.ownerState.value = self.isChallengeOwner(challenge: challenge)
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

    func didTappedEditBarButton() {
        guard let challengeID = challengeID else { return }
        self.editBarButtonTap.send(challengeID)
    }

    func didTappedParticipationAuthButton() {
        guard let challengeID = challengeID else { return }
        if participationAuthState.value == .notParticipating {
            participationCreateUsecase.createParticipation(challengeID: challengeID)
            self.participationAuthState.value = .notAuthenticating
            participationButtonTap.send()
        } else if participationAuthState.value == .notAuthenticating {
            authButtonTap.send(challengeID)
        }
    }

    func didTappedAlertConfirm() {
        alertConfirmTap.send()
    }

    func didTappedAllAuthDisplayView() {
        guard let challengeID = challengeID else { return }
        allAuthDisplayViewTap.send(challengeID)
    }

    func didTappedMyAuthDisplayView() {
        guard let challengeID = challengeID else { return }
        myAuthDisplayViewTap.send(challengeID)
    }

    func didTappedAuthMethodImage(imageData: Data) {
        self.authMethodImageTap.send(imageData)
    }

    func loadAuthMethodImage(imageData: Data) {
        self.authMethodImageLoad.send(imageData)
    }

    func fetchParticipationAuthState() {
        self.updateParticipationAuthState()
    }

    func updateParticipantCount() {
        guard let challengeID = challengeID else { return }
        challengeUpdateUsecase.updateParticipantCount(challengeID: challengeID)
        achievementUpdateUsecase.updateTotalCount()
    }
}

extension DetailViewModel {
    private func fetchParticipation(completion: @escaping (Participation?) -> Void) {
        guard let challengeID = challengeID else { return }
        self.participationFetchUsecase.fetchParticipation(challengeID: challengeID) { participation in
            completion(participation)
        }
    }

    private func fetchAuth(completion: @escaping (ChallengeAuth?) -> Void) {
        guard let challengeID = challengeID else { return }
        self.challengeAuthFetchUsecase.fetchChallengeAuth(challengeID: challengeID) { challengeAuth in
            completion(challengeAuth)
        }
    }

    private func updateParticipationAuthState() {
        self.fetchParticipation { [weak self] participation in
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
}
