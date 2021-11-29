//
//  CreateViewModel.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/09.
//

import Combine
import Foundation

enum ButtonType: String {
    case create = "create"
    case update = "edit"

    var confirmMessage: String {
        switch self {
        case .create:
            return "challenge created".localized
        case .update:
            return "challenge edited".localized
        }
    }
}

protocol CreateViewModelInput {
    func update(category: Challenge.Category)
    func update(title: String)
    func update(imageURL: String?)
    func update(thumbnailImageURL: String?)
    func update(week: Int)
    func update(introduction: String)
    func update(authMethod: String)
    func update(authExampleImageURL: String?)
    func update(authExampleThumbnailImageURL: String?)
    func didTappedCreateButton()
    func validateTextView(currentText: String, range: NSRange, text: String) -> Bool
    func validateTextField(currentText: String, range: NSRange, text: String) -> Bool
    func validateWeek(currentText: String) -> String
    func didLoadedChallenge()
    func updateChallenge()
    func saveImage(to directory: String, filename: String, data: Data?) -> String?
    func imageData(from directory: String, filename: String, completion: ((Data?) -> Void)?)
    
}

protocol CreateViewModelOutput {
    var buttonType: CurrentValueSubject<ButtonType, Never> { get }
    var buttonState: CurrentValueSubject<Bool, Never> { get }
    var expectedEndDate: CurrentValueSubject<Date, Never> { get }
    var challenge: CurrentValueSubject<Challenge?, Never> { get }
}

protocol CreateViewModelIO: CreateViewModelInput, CreateViewModelOutput { }

final class CreateViewModel: CreateViewModelIO {
    var buttonType = CurrentValueSubject<ButtonType, Never>(.create)
    var buttonState = CurrentValueSubject<Bool, Never>(false)
    var expectedEndDate = CurrentValueSubject<Date, Never>(Calendar.current.date(byAdding: DateComponents(day: 7), to: Date()) ?? Date())
    var challenge = CurrentValueSubject<Challenge?, Never>(nil)

    var cancellables = Set<AnyCancellable>()
    var challengeCreateUsecase: ChallengeCreatableUsecase
    var challengeUpdateUsecase: ChallengeUpdatableUsecase
    var challengeFetchUsecase: ChallengeFetchableUsecase
    var imageFetchUsecase: ImageFetchableUsecase
    var imageSaveUsecase: ImageSavableUsecase
    var imageUpdateUsecase: ImageUpdatableUsecase
    var challengeID: String?

    private var title: String
    private var category: Challenge.Category?
    private var imageURL: String
    private var thumbnailImageURL: String
    private var week: Int
    private var introduction: String
    private var authMethod: String
    private var authExampleImageURL: String
    private var authExampleThumbnailImageURL: String

    private var isChangedImage: Bool
    private var isChangedAuthImage: Bool

    init(challengeID: String? = nil,
         challengeCreateUsecase: ChallengeCreatableUsecase,
         challengeUpdateUsecase: ChallengeUpdatableUsecase,
         challengeFetchUsecase: ChallengeFetchableUsecase,
         imageFetchUsecase: ImageFetchableUsecase,
         imageSaveUsecase: ImageSavableUsecase,
         imageUpdateUsecase: ImageUpdatableUsecase) {
        self.challengeID = challengeID
        self.challengeCreateUsecase = challengeCreateUsecase
        self.challengeUpdateUsecase = challengeUpdateUsecase
        self.challengeFetchUsecase = challengeFetchUsecase
        self.imageFetchUsecase = imageFetchUsecase
        self.imageSaveUsecase = imageSaveUsecase
        self.imageUpdateUsecase = imageUpdateUsecase
        self.title = ""
        self.category = .exercise
        self.imageURL = ""
        self.thumbnailImageURL = ""
        self.week = 1
        self.introduction = ""
        self.authMethod = ""
        self.authExampleImageURL = ""
        self.authExampleThumbnailImageURL = ""
        self.isChangedImage = false
        self.isChangedAuthImage = false
    }
}

extension CreateViewModel {
    func update(category: Challenge.Category) {
        self.category = category
        validate()
    }

    func update(title: String) {
        self.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        validate()
    }

    func update(imageURL: String?) {
        self.imageURL = imageURL ?? ""
        isChangedImage = true
        validate()
    }

    func update(thumbnailImageURL: String?) {
        self.thumbnailImageURL = thumbnailImageURL ?? ""
        validate()
    }

    func update(week: Int) {
        guard let endDate = challengeCreateUsecase.endDate(week: week) else { return }
        self.week = week
        expectedEndDate.value = endDate
        validate()
    }

    func update(introduction: String) {
        self.introduction = introduction.trimmingCharacters(in: .whitespacesAndNewlines)
        validate()
    }

    func update(authMethod: String) {
        self.authMethod = authMethod.trimmingCharacters(in: .whitespacesAndNewlines)
        validate()
    }

    func update(authExampleImageURL: String?) {
        self.authExampleImageURL = authExampleImageURL ?? ""
        isChangedAuthImage = true
        validate()
    }

    func update(authExampleThumbnailImageURL: String?) {
        self.authExampleThumbnailImageURL = authExampleThumbnailImageURL ?? ""
        validate()
    }

    func updateAll(challenge: Challenge) {
        guard let startDate = challenge.startDate else { return }

        self.category = challenge.category
        self.title = challenge.title
        self.imageURL = challenge.imageURL
        self.thumbnailImageURL = challenge.thumbnailImageURL
        self.week = challenge.week
        self.introduction = challenge.introduction
        self.authMethod = challenge.authMethod
        self.authExampleImageURL = challenge.authExampleImageURL
        self.authExampleThumbnailImageURL = challenge.authExampleThumbnailImageURL
        guard let endDate = challengeUpdateUsecase.endDate(startDate: startDate,
                                                           week: week) else { return }
        expectedEndDate.value = endDate
        validate()
    }

    func didTappedCreateButton() {
        guard let category = category else { return }
        if buttonType.value == .create {
            challengeCreateUsecase.createChallenge(
                category: category,
                title: title,
                imageURL: imageURL,
                thumbnailImageURL: thumbnailImageURL,
                authExampleImageURL: authExampleImageURL,
                authExampleThumbnailImageURL: authExampleThumbnailImageURL,
                authMethod: authMethod,
                week: week,
                introduction: introduction
            )
        } else {
            updateChallenge()
        }
    }

    func validateTextView(currentText: String, range: NSRange, text: String) -> Bool {
        let newLength = currentText.count + text.count - range.length
        return newLength <= 150
    }

    func validateTextField(currentText: String, range: NSRange, text: String) -> Bool {
        let newLength = currentText.count + text.count - range.length
        return newLength <= 50
    }

    func validateWeek(currentText: String) -> String {
        guard let week = Int(currentText) else { return "" }
        return "\(min(max(week, 0), 52))"
    }

    func didLoadedChallenge() {
        fetchChallenge()
    }

    func updateChallenge() {
        guard let challenge = challenge.value,
              let startDate = challenge.startDate,
              let endDate = challengeUpdateUsecase.endDate(startDate: startDate, week: week),
              let category = category else { return }

        let updateChallenge = Challenge(challengeID: challenge.challengeID,
                                        title: title,
                                        introduction: introduction,
                                        category: category,
                                        imageURL: imageURL,
                                        thumbnailImageURL: thumbnailImageURL,
                                        authExampleImageURL: authExampleImageURL,
                                        authExampleThumbnailImageURL: authExampleThumbnailImageURL,
                                        authMethod: authMethod,
                                        startDate: challenge.startDate,
                                        endDate: endDate,
                                        ownerID: challenge.ownerID,
                                        week: week,
                                        participantCount: challenge.participantCount)

        challengeUpdateUsecase.update(challenge: updateChallenge)
        imageUpdateUsecase.updateImage(challenge: updateChallenge,
                                       isChangedImage: isChangedImage,
                                       isChangedAuthImage: isChangedAuthImage)
    }

    func saveImage(to directory: String, filename: String, data: Data?) -> String? {
        return imageSaveUsecase.saveImage(to: directory, filename: filename, data: data)
    }

    func imageData(from directory: String, filename: String, completion: ((Data?) -> Void)? = nil) {
        imageFetchUsecase.fetchImageData(from: directory, filename: filename) { data in
            completion?(data)
        }
    }
}

extension CreateViewModel {
    private func validate() {
        buttonState.value = !challengeCreateUsecase.isEmpty(
            title: title,
            imageURL: imageURL,
            introduction: introduction,
            authMethod: authMethod,
            authExampleImageURL: authExampleImageURL
        )
    }

    private func fetchChallenge() {
        guard let challengeID = challengeID else { return }
        challengeFetchUsecase.fetchEdittingChallenge(challengeID: challengeID) { [weak self] existedChallenge in
            guard let self = self,
                  let challenge = existedChallenge else { return }
            self.challenge.value = challenge
            self.buttonType.value = .update
            self.updateAll(challenge: challenge)
        }
    }
}
