//
//  DetailViewModel.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/17.
//

import Combine
import Foundation

enum ParticipationAuthState: String {
    case unParticipation = "참여하기"
    case unAuth = "인증하기"
    case auth = "인증완료"
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
    var participationAuthState = CurrentValueSubject<ParticipationAuthState, Never>(.unParticipation)

    var challenge = PassthroughSubject<Challenge, Never>()
    var editBarButtonTap = PassthroughSubject<String, Never>()
    var participationButtonTap = PassthroughSubject<Void, Never>()

    let challengeFetchUsecase: ChallengeFetchableUsecase
    let imageFetchUsecase: ImageFetchableUsecase
    let participationFetchUsecase: ParticipationFetchableUsecase
    let participationCreateUsecase: ParticipationCreatableUsecase
    var cancellables = Set<AnyCancellable>()
    var challengeID: String?

    init(challengeID: String,
         challengeFetchUsecase: ChallengeFetchableUsecase,
         imageFetchUsecase: ImageFetchableUsecase,
         participationFetchUsecase: ParticipationFetchableUsecase,
         participationCreateUsecase: ParticipationCreatableUsecase) {
        self.challengeID = challengeID
        self.challengeFetchUsecase = challengeFetchUsecase
        self.imageFetchUsecase = imageFetchUsecase
        self.participationFetchUsecase = participationFetchUsecase
        self.participationCreateUsecase = participationCreateUsecase
        self.fetchChallenge()
    }
}

extension DetailViewModel {
    func didTappedEditBarButton() {
        guard let challengeID = challengeID else { return }
        self.editBarButtonTap.send(challengeID)
    }

    func didTappedParticipationButton() {
        if participationAuthState.value == .unParticipation {
            guard let challengeID = challengeID else { return }
            participationCreateUsecase.createParticipation(challengeID: challengeID)
            self.participationAuthState.value = .unAuth
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

    private func fetchParticipation() {
        guard let challengeID = challengeID else { return }
        participationFetchUsecase.fetchParticipation(challengeID: challengeID) { [weak self] participation in
            guard let self = self else { return }
            // particia 있으면 -> 인증하기 or 인증완료 
            // 없으면 -> 참여하기
            self.participationAuthState.value = participation == nil ? .unParticipation : .unAuth
        }
    }

    private func isChallengeOwner(challenge: Challenge) -> Bool {
        // TODO: userID 가져오는 로직 별도 분리
        return challenge.ownerID == RoutinusRepository.userID()
    }

    func imageData(from directory: String,
                   filename: String,
                   completion: ((Data?) -> Void)? = nil) {
        imageFetchUsecase.fetchImageData(from: directory, filename: filename) { data in
            completion?(data)
        }
    }
}
