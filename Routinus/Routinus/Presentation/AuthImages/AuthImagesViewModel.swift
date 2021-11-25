//
//  AuthImagesViewModel.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/24.
//

import Combine
import Foundation

protocol AuthImagesViewModelInput {
    func imageData(from directory: String,
                   filename: String,
                   completion: ((Data?) -> Void)?)
}

protocol AuthImagesViewModelOutput {
    var auths: CurrentValueSubject<[ChallengeAuth], Never> { get }
    var authDisplayState: CurrentValueSubject<AuthDisplayState, Never> { get }
}

protocol AuthImagesViewModelIO: AuthImagesViewModelInput, AuthImagesViewModelOutput { }

final class AuthImagesViewModel: AuthImagesViewModelIO {
    var auths = CurrentValueSubject<[ChallengeAuth], Never>([])
    var authDisplayState = CurrentValueSubject<AuthDisplayState, Never>(.all)

    let challengeAuthFetchUsecase: ChallengeAuthFetchableUsecase
    let imageFetchUsecase: ImageFetchableUsecase

    private var challengeID: String?

    init(challengeID: String,
         authDisplayState: AuthDisplayState,
         challengeAuthFetchUsecase: ChallengeAuthFetchableUsecase,
         imageFetchUsecase: ImageFetchableUsecase) {
        self.challengeID = challengeID
        self.challengeAuthFetchUsecase = challengeAuthFetchUsecase
        self.imageFetchUsecase = imageFetchUsecase

        self.fetchChallengeAuthData(authDisplayState: authDisplayState)
    }

    func imageData(from directory: String,
                   filename: String,
                   completion: ((Data?) -> Void)? = nil) {
        imageFetchUsecase.fetchImageData(from: directory, filename: filename) { data in
            completion?(data)
        }
    }
}

extension AuthImagesViewModel {
    private func fetchChallengeAuthData(authDisplayState: AuthDisplayState) {
        switch authDisplayState {
        case .all:
            self.authDisplayState.value = .all
            self.fetchChallengeAuths()
        case .my:
            self.authDisplayState.value = .my
            self.fetchMyChallengeAuths()
        }
    }

    private func fetchChallengeAuths() {
        guard let challengeID = challengeID else { return }
        challengeAuthFetchUsecase.fetchChallengeAuths(challengeID: challengeID) { challengeAuths in
            self.auths.value = challengeAuths
        }
    }

    private func fetchMyChallengeAuths() {
        guard let challengeID = challengeID else { return }
        challengeAuthFetchUsecase.fetchMyChallengeAuths(challengeID: challengeID) { challengeAuths in
            self.auths.value = challengeAuths
        }
    }
}
