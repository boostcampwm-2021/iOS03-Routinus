//
//  CreateViewModel.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/09.
//

import Combine
import Foundation

protocol CreateViewModelInput {
    func update(category: Challenge.Category)
    func update(title: String)
    func update(imageURL: String?)
    func update(week: Int)
    func update(introduction: String)
    func update(authMethod: String)
    func update(authExampleImageURL: String?)
    func didTappedCreateButton()
    func validateTextView(currentText: String, range: NSRange, text: String) -> Bool
    func validateTextField(currentText: String, range: NSRange, text: String) -> Bool
    func fetchChallenge()
    func updateChallenge(category: Challenge.Category, title: String, imageURL: String, week: Int, introduction: String, authMethod: String, authExampleImageURL: String)
    func validateWeek(currentText: String) -> String
    func saveImage(to directory: String, filename: String, data: Data?) -> String?
}

protocol CreateViewModelOutput {
    var createButtonState: CurrentValueSubject<Bool, Never> { get }
    var expectedEndDate: CurrentValueSubject<Date, Never> { get }
    var challenge: CurrentValueSubject<Challenge?, Never> { get }
}

protocol CreateViewModelIO: CreateViewModelInput, CreateViewModelOutput { }

final class CreateViewModel: CreateViewModelIO {
    var createButtonState = CurrentValueSubject<Bool, Never>(false)
    var expectedEndDate = CurrentValueSubject<Date, Never>(Calendar.current.date(byAdding: DateComponents(day: 7), to: Date()) ?? Date())
    var challenge = CurrentValueSubject<Challenge?, Never>(nil)
    
    var cancellables = Set<AnyCancellable>()
    var createUsecase: ChallengeCreatableUsecase
    var updateUsecase: ChallengeUpdatableUsecase
    var challengeID: String?

    private var title: String
    private var category: Challenge.Category?
    private var imageURL: String
    private var week: Int
    private var introduction: String
    private var authMethod: String
    private var authExampleImageURL: String

    init(challengeID: String? = nil, createUsecase: ChallengeCreatableUsecase, updateUsecase: ChallengeUpdatableUsecase) {
        self.challengeID = challengeID
        self.createUsecase = createUsecase
        self.updateUsecase = updateUsecase
        self.title = ""
        self.imageURL = ""
        self.week = 1
        self.introduction = ""
        self.authMethod = ""
        self.authExampleImageURL = ""
        self.category = .exercise
    }

    private func validate() {
        createButtonState.value = !createUsecase.isEmpty(title: title,
                                                         imageURL: imageURL,
                                                         introduction: introduction,
                                                         authMethod: authMethod,
                                                         authExampleImageURL: authExampleImageURL)
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

    func update(category: Challenge.Category) {
        self.category = category
        self.validate()
    }

    func update(title: String) {
        self.title = title
        self.validate()
    }

    func update(imageURL: String?) {
        self.imageURL = imageURL ?? ""
        self.validate()
    }

    func update(week: Int) {
        guard let endDate = createUsecase.endDate(week: week) else { return }
        self.week = week
        expectedEndDate.value = endDate
        self.validate()
    }

    func update(introduction: String) {
        self.introduction = introduction
        self.validate()
    }

    func update(authMethod: String) {
        self.authMethod = authMethod
        self.validate()
    }

    func update(authExampleImageURL: String?) {
        self.authExampleImageURL = authExampleImageURL ?? ""
        self.validate()
    }

    func didTappedCreateButton() {
        guard let category = category else { return }
        createUsecase.createChallenge(category: category,
                                      title: title,
                                      imageURL: imageURL,
                                      authExampleImageURL: authExampleImageURL,
                                      authMethod: authMethod,
                                      week: week,
                                      introduction: introduction)
    }

    func fetchChallenge() {
        guard let challengeID = challengeID else { return }
        updateUsecase.fetchChallenge(challengeID: challengeID) { [weak self] existedChallenge in
            guard let self = self,
                  let challenge = existedChallenge else { return }
            self.challenge.value = challenge
        }
    }

    func updateChallenge(category: Challenge.Category, title: String, imageURL: String, week: Int, introduction: String, authMethod: String, authExampleImageURL: String) {
        guard let challenge = challenge.value,
              let startDate = challenge.startDate,
              let endDate = updateUsecase.endDate(startDate: startDate, week: week) else { return }
        let updateChallenge = Challenge(challengeID: challenge.challengeID,
                                        title: title,
                                        introduction: introduction,
                                        category: category,
                                        imageURL: imageURL,
                                        authExampleImageURL: authExampleImageURL,
                                        thumbnailImageURL: challenge.thumbnailImageURL,
                                        authMethod: authMethod,
                                        startDate: challenge.startDate,
                                        endDate: endDate,
                                        ownerID: challenge.ownerID,
                                        week: week,
                                        participantCount: challenge.participantCount)
        self.challenge.value = updateChallenge
        updateUsecase.updateChallenge(challenge: updateChallenge)
    }

    func saveImage(to directory: String, filename: String, data: Data?) -> String? {
        return createUsecase.saveImage(to: directory, filename: filename, data: data)
    }
}
