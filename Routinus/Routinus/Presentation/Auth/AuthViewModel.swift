//
//  AuthViewModel.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/16.
//

import Combine
import Foundation

protocol AuthViewModelInput {
    func didTappedAuthButton()
    func update(userAuthImageURL: String?)
    func update(userAuthThumbnailImageURL: String?)
    func imageData(from directory: String,
                   filename: String,
                   completion: ((Data?) -> Void)?)
    func saveImage(to directory: String,
                   filename: String,
                   data: Data?) -> String?
}

protocol AuthViewModelOutput {
    var authButtonState: CurrentValueSubject<Bool, Never> { get }
    var challenge: CurrentValueSubject<Challenge?, Never> { get }
}

protocol AuthViewModelIO: AuthViewModelInput, AuthViewModelOutput { }

class AuthViewModel: AuthViewModelIO {
    var authButtonState = CurrentValueSubject<Bool, Never>(false)
    var challenge = CurrentValueSubject<Challenge?, Never>(nil)
    var challengeFetchUsecase: ChallengeFetchableUsecase
    var imageFetchUsecase: ImageFetchableUsecase
    var imageSaveUsecase: ImageSavableUsecase
    var challengeAuthCreateUsecase: ChallengeAuthCreatableUsecase

    private var challengeID: String
    private var userAuthImageURL: String
    private var userAuthThumbnailImageURL: String

    init(challengeID: String,
         challengeFetchUsecase: ChallengeFetchableUsecase,
         imageFetchUsecase: ImageFetchableUsecase,
         imageSaveUsecase: ImageSavableUsecase,
         challengeAuthCreateUsecase: ChallengeAuthCreatableUsecase) {
        self.challengeID = challengeID
        self.challengeFetchUsecase = challengeFetchUsecase
        self.imageFetchUsecase = imageFetchUsecase
        self.imageSaveUsecase = imageSaveUsecase
        self.challengeAuthCreateUsecase = challengeAuthCreateUsecase
        self.userAuthImageURL = ""
        self.userAuthThumbnailImageURL = ""
        self.fetchChallenge(challengeID: challengeID)
    }

    private func validate() {
        authButtonState.value = !userAuthImageURL.isEmpty && !userAuthThumbnailImageURL.isEmpty
    }
}

extension AuthViewModel {
    func didTappedAuthButton() {
        self.challengeAuthCreateUsecase.createChallengeAuth(challengeID: challengeID,
                                                            userAuthImageURL: userAuthImageURL,
                                                            userAuthThumbnailImageURL: userAuthThumbnailImageURL)
    }

    func update(userAuthImageURL: String?) {
        self.userAuthImageURL = userAuthImageURL ?? ""
        self.validate()
    }

    func update(userAuthThumbnailImageURL: String?) {
        self.userAuthThumbnailImageURL = userAuthThumbnailImageURL ?? ""
        self.validate()
    }

    func imageData(from directory: String,
                   filename: String,
                   completion: ((Data?) -> Void)? = nil) {
        self.imageFetchUsecase.fetchImageData(from: directory, filename: filename) { data in
            completion?(data)
        }
    }

    func saveImage(to directory: String, filename: String, data: Data?) -> String? {
        return imageSaveUsecase.saveImage(to: directory, filename: filename, data: data)
    }
}

extension AuthViewModel {
    private func fetchChallenge(challengeID: String) {
        self.challengeFetchUsecase.fetchChallenge(challengeID: challengeID) { [weak self] challenge in
            guard let self = self else { return }
            self.challenge.value = challenge
        }
    }
}
