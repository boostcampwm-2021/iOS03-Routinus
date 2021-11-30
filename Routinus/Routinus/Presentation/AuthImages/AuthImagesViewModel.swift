//
//  AuthImagesViewModel.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/24.
//

import Combine
import Foundation

protocol AuthImagesViewModelInput {
    func fetchAuthData(authDisplayState: AuthDisplayState)
    func imageData(from directory: String, filename: String, completion: ((Data?) -> Void)?)
}

protocol AuthImagesViewModelOutput {
    var auths: CurrentValueSubject<[Auth], Never> { get }
    var authDisplayState: CurrentValueSubject<AuthDisplayState, Never> { get }

    var authImageTap: PassthroughSubject<Data, Never> { get }
    var authImageLoad: PassthroughSubject<Data, Never> { get }
}

protocol AuthImagesViewModelIO: AuthImagesViewModelInput, AuthImagesViewModelOutput { }

final class AuthImagesViewModel: AuthImagesViewModelIO {
    var auths = CurrentValueSubject<[Auth], Never>([])
    var authDisplayState = CurrentValueSubject<AuthDisplayState, Never>(.all)

    var authImageTap = PassthroughSubject<Data, Never>()
    var authImageLoad = PassthroughSubject<Data, Never>()

    private var challengeID: String?

    let authFetchUsecase: AuthFetchableUsecase
    let imageFetchUsecase: ImageFetchableUsecase

    init(challengeID: String,
         authDisplayState: AuthDisplayState,
         authFetchUsecase: AuthFetchableUsecase,
         imageFetchUsecase: ImageFetchableUsecase) {
        self.challengeID = challengeID
        self.authFetchUsecase = authFetchUsecase
        self.imageFetchUsecase = imageFetchUsecase
        fetchAuthData(authDisplayState: authDisplayState)
    }
}

extension AuthImagesViewModel {
    private func fetchAuths() {
        guard let challengeID = challengeID else { return }
        authFetchUsecase.fetchAuths(challengeID: challengeID) { auths in
            self.auths.value = auths
        }
    }

    private func fetchMyAuths() {
        guard let challengeID = challengeID else { return }
        authFetchUsecase.fetchMyAuths(challengeID: challengeID) { auths in
            self.auths.value = auths
        }
    }
}

extension AuthImagesViewModel: AuthImagesViewModelInput {
    func fetchAuthData(authDisplayState: AuthDisplayState) {
        switch authDisplayState {
        case .all:
            self.authDisplayState.value = .all
            self.fetchAuths()
        case .my:
            self.authDisplayState.value = .my
            self.fetchMyAuths()
        }
    }

    func imageData(from directory: String, filename: String, completion: ((Data?) -> Void)? = nil) {
        imageFetchUsecase.fetchImageData(from: directory, filename: filename) { data in
            completion?(data)
        }
    }
}
