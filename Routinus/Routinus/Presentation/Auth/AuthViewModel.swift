//
//  AuthViewModel.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/16.
//

import Combine
import Foundation

protocol AuthViewModelInput {
    func fetchChallenge(challengeID: String)
    func didTappedAuthButton()
    func didTappedAuthMethodImage(image: Data)
    func loadedAuthMethodImage(image: Data)
    func update(userAuthImageURL: String?)
    func update(userAuthThumbnailImageURL: String?)
    func imageData(from directory: String, filename: String, completion: ((Data?) -> Void)?)
    func saveImage(to directory: String, filename: String, data: Data?) -> String?
}

protocol AuthViewModelOutput {
    var authButtonState: CurrentValueSubject<Bool, Never> { get }
    var challenge: CurrentValueSubject<Challenge?, Never> { get }
    var alertConfirmTap: PassthroughSubject<Void, Never> { get }
    var authMethodImageTap: PassthroughSubject<Data, Never> { get }
    var authMethodImageLoad: PassthroughSubject<Data, Never> { get }
    var userName: String { get }
}

protocol AuthViewModelIO: AuthViewModelInput, AuthViewModelOutput { }

final class AuthViewModel: AuthViewModelIO {
    var authButtonState = CurrentValueSubject<Bool, Never>(false)
    var challenge = CurrentValueSubject<Challenge?, Never>(nil)
    var alertConfirmTap = PassthroughSubject<Void, Never>()
    var authMethodImageTap = PassthroughSubject<Data, Never>()
    var authMethodImageLoad = PassthroughSubject<Data, Never>()
    var userName: String = ""
    var challengeFetchUsecase: ChallengeFetchableUsecase
    var imageFetchUsecase: ImageFetchableUsecase
    var imageSaveUsecase: ImageSavableUsecase
    var challengeAuthCreateUsecase: ChallengeAuthCreatableUsecase
    var participationUpdateUsecase: ParticipationUpdatableUsecase
    var achievementUpdateUsecase: AchievementUpdatableUsecase
    var userUpdateUsecase: UserUpdatableUsecase
    var userFetchUsecase: UserFetchableUsecase

    private var challengeID: String
    private var userAuthImageURL: String
    private var userAuthThumbnailImageURL: String

    init(challengeID: String,
         challengeFetchUsecase: ChallengeFetchableUsecase,
         imageFetchUsecase: ImageFetchableUsecase,
         imageSaveUsecase: ImageSavableUsecase,
         challengeAuthCreateUsecase: ChallengeAuthCreatableUsecase,
         participationUpdateUsecase: ParticipationUpdatableUsecase,
         achievementUpdateUsecase: AchievementUpdatableUsecase,
         userUpdateUsecase: UserUpdatableUsecase,
         userFetchUsecase: UserFetchableUsecase) {
        self.challengeID = challengeID
        self.challengeFetchUsecase = challengeFetchUsecase
        self.imageFetchUsecase = imageFetchUsecase
        self.imageSaveUsecase = imageSaveUsecase
        self.challengeAuthCreateUsecase = challengeAuthCreateUsecase
        self.participationUpdateUsecase = participationUpdateUsecase
        self.achievementUpdateUsecase = achievementUpdateUsecase
        self.userUpdateUsecase = userUpdateUsecase
        self.userFetchUsecase = userFetchUsecase
        self.userAuthImageURL = ""
        self.userAuthThumbnailImageURL = ""
        self.fetchChallenge(challengeID: challengeID)
        self.fetchUsername()
    }

    private func validate() {
        authButtonState.value = !userAuthImageURL.isEmpty && !userAuthThumbnailImageURL.isEmpty
    }
}

extension AuthViewModel {
    func didTappedAuthButton() {
        challengeAuthCreateUsecase.createChallengeAuth(
            challengeID: challengeID,
            userAuthImageURL: userAuthImageURL,
            userAuthThumbnailImageURL: userAuthThumbnailImageURL
        )
        participationUpdateUsecase.updateParticipationAuthCount(challengeID: challengeID)
        achievementUpdateUsecase.updateAchievementCount()
        userUpdateUsecase.updateContinuityDayByAuth()
    }

    func didTappedAuthMethodImage(image: Data) {
        authMethodImageTap.send(image)
    }

    func loadedAuthMethodImage(image: Data) {
        authMethodImageLoad.send(image)
    }

    func update(userAuthImageURL: String?) {
        self.userAuthImageURL = userAuthImageURL ?? ""
        validate()
    }

    func update(userAuthThumbnailImageURL: String?) {
        self.userAuthThumbnailImageURL = userAuthThumbnailImageURL ?? ""
        validate()
    }

    func imageData(from directory: String,
                   filename: String,
                   completion: ((Data?) -> Void)? = nil) {
        imageFetchUsecase.fetchImageData(from: directory, filename: filename) { data in
            completion?(data)
        }
    }

    func saveImage(to directory: String, filename: String, data: Data?) -> String? {
        return imageSaveUsecase.saveImage(to: directory, filename: filename, data: data)
    }

    func fetchUsername() {
        guard let userID = userFetchUsecase.fetchUserID() else { return }
        userFetchUsecase.fetchUser(id: userID) { [weak self] user in
            guard let self = self else { return }
            self.userName = user.name
        }
    }
}

extension AuthViewModel {
    func fetchChallenge(challengeID: String) {
        challengeFetchUsecase.fetchChallenge(challengeID: challengeID) { [weak self] challenge in
            guard let self = self else { return }
            self.challenge.value = challenge
        }
    }
}
