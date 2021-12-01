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
    func loadedAuthMethodImage(imageData: Data)
    func updateParticipantCount()
    func imageData(from directory: String, filename: String, completion: ((Data?) -> Void)?)
    func didTappedEditBarButton()
    func didTappedAuthMethodImage(imageData: Data)
    func didTappedAllAuthDisplayView()
    func didTappedMyAuthDisplayView()
    func didTappedParticipationAuthButton()
}

protocol DetailViewModelOutput {
    var ownerState: CurrentValueSubject<Bool, Never> { get }
    var participationAuthState: CurrentValueSubject<ParticipationAuthState, Never> { get }

    var challenge: PassthroughSubject<Challenge, Never> { get }
    var authButtonTap: PassthroughSubject<String, Never> { get }
    var editBarButtonTap: PassthroughSubject<String, Never> { get }
    var authMethodImageTap: PassthroughSubject<Data, Never> { get }
    var authMethodImageLoad: PassthroughSubject<Data, Never> { get }
    var participationButtonTap: PassthroughSubject<Void, Never> { get }
    var myAuthDisplayViewTap: PassthroughSubject<String, Never> { get }
    var allAuthDisplayViewTap: PassthroughSubject<String, Never> { get }

    var challengeID: String? { get }
}

protocol DetailViewModelIO: DetailViewModelInput, DetailViewModelOutput { }

class DetailViewModel: DetailViewModelIO {
    var ownerState = CurrentValueSubject<Bool, Never>(false)
    var participationAuthState = CurrentValueSubject<ParticipationAuthState, Never>(.notParticipating)

    var cancellables = Set<AnyCancellable>()
    private(set) var challengeID: String?

    var challenge = PassthroughSubject<Challenge, Never>()
    var editBarButtonTap = PassthroughSubject<String, Never>()
    var participationButtonTap = PassthroughSubject<Void, Never>()
    var authButtonTap = PassthroughSubject<String, Never>()
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
    let authFetchUsecase: AuthFetchableUsecase
    let achievementUpdateUsecase: AchievementUpdatableUsecase

    let challengeUpdatePublisher = NotificationCenter.default.publisher(
        for: ChallengeUpdateUsecase.didUpdateChallenge,
        object: nil
    )
    let challengeImageUpdatePublisher = NotificationCenter.default.publisher(
        for: ImageUpdateUsecase.didUpdateChallengeImage,
        object: nil
    )
    let authCreatePublisher = NotificationCenter.default.publisher(
        for: AuthCreateUsecase.didCreateAuth,
        object: nil
    )
    let participationCreatePublisher = NotificationCenter.default.publisher(
        for: ParticipationCreateUsecase.didCreateParticipation,
        object: nil
    )
    let participationUpdatePublisher = NotificationCenter.default.publisher(
        for: ParticipationUpdateUsecase.didUpdateParticipation,
        object: nil
    )

    init(challengeID: String,
         challengeFetchUsecase: ChallengeFetchableUsecase,
         challengeUpdateUsecase: ChallengeUpdatableUsecase,
         imageFetchUsecase: ImageFetchableUsecase,
         participationFetchUsecase: ParticipationFetchableUsecase,
         participationCreateUsecase: ParticipationCreatableUsecase,
         userFetchUsecase: UserFetchableUsecase,
         authFetchUsecase: AuthFetchableUsecase,
         achievementUpdateUsecase: AchievementUpdatableUsecase) {
        self.challengeID = challengeID
        self.challengeFetchUsecase = challengeFetchUsecase
        self.challengeUpdateUsecase = challengeUpdateUsecase
        self.imageFetchUsecase = imageFetchUsecase
        self.participationFetchUsecase = participationFetchUsecase
        self.participationCreateUsecase = participationCreateUsecase
        self.userFetchUsecase = userFetchUsecase
        self.authFetchUsecase = authFetchUsecase
        self.achievementUpdateUsecase = achievementUpdateUsecase
        self.configurePublishers()
        self.fetchChallenge()
        self.updateParticipationAuthState()
    }
}

extension DetailViewModel {
    func configurePublishers() {
        challengeUpdatePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.fetchChallenge()
            }
            .store(in: &cancellables)

        challengeImageUpdatePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.fetchChallenge()
            }
            .store(in: &cancellables)

        authCreatePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.updateParticipationAuthState()
            }
            .store(in: &cancellables)

        participationCreatePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.updateParticipationAuthState()
            }
            .store(in: &cancellables)

        participationUpdatePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.updateParticipationAuthState()
            }
            .store(in: &cancellables)
    }

    private func fetchParticipation(completion: @escaping (Participation?) -> Void) {
        guard let challengeID = challengeID else { return }
        participationFetchUsecase.fetchParticipation(challengeID: challengeID) { participation in
            completion(participation)
        }
    }

    private func fetchAuth(completion: @escaping (Auth?) -> Void) {
        guard let challengeID = challengeID else { return }
        authFetchUsecase.fetchAuth(challengeID: challengeID) { auth in
            completion(auth)
        }
    }

    private func updateParticipationAuthState() {
        fetchParticipation { [weak self] participation in
            guard let self = self else { return }
            if participation == nil {
                self.participationAuthState.value = .notParticipating
            } else {
                self.fetchAuth { [weak self] auth in
                    guard let self = self else { return }
                    self.participationAuthState.value = auth == nil ? .notAuthenticating : .authenticated
                }
            }
        }
    }

    private func isChallengeOwner(challenge: Challenge) -> Bool {
        return challenge.ownerID == userFetchUsecase.fetchUserID()
    }
}

extension DetailViewModel: DetailViewModelInput {
    func fetchChallenge() {
        guard let challengeID = challengeID else { return }
        challengeFetchUsecase.fetchChallenge(challengeID: challengeID) { [weak self] challenge in
            guard let self = self else { return }
            self.ownerState.value = self.isChallengeOwner(challenge: challenge)
            self.challenge.send(challenge)
        }
    }

    func loadedAuthMethodImage(imageData: Data) {
        authMethodImageLoad.send(imageData)
    }

    func updateParticipantCount() {
        guard let challengeID = challengeID else { return }
        challengeUpdateUsecase.updateParticipantCount(challengeID: challengeID)
        achievementUpdateUsecase.updateTotalCount()
    }

    func imageData(from directory: String, filename: String, completion: ((Data?) -> Void)? = nil) {
        imageFetchUsecase.fetchImageData(from: directory, filename: filename) { data in
            completion?(data)
        }
    }

    func didTappedEditBarButton() {
        guard let challengeID = challengeID else { return }
        editBarButtonTap.send(challengeID)
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
        authMethodImageTap.send(imageData)
    }

    func didTappedParticipationAuthButton() {
        guard let challengeID = challengeID else { return }
        if participationAuthState.value == .notParticipating {
            participationCreateUsecase.createParticipation(challengeID: challengeID)
            participationAuthState.value = .notAuthenticating
            participationButtonTap.send()
        } else if participationAuthState.value == .notAuthenticating {
            authButtonTap.send(challengeID)
        }
    }
}
