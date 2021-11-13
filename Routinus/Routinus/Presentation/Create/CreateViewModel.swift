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
    func update(imageURL: String)
    func update(week: Int)
    func update(introduction: String)
    func update(authMethod: String)
    func update(authExampleImageURL: String)
    func didTappedCreateButton()
    func validateTextView(currentText: String, range: NSRange, text: String) -> Bool
    func validateTextField(currentText: String, range: NSRange, text: String) -> Bool
    func validateWeek(currentText: String) -> String
}

protocol CreateViewModelOutput {
    var createButtonState: CurrentValueSubject<Bool, Never> { get }
    var expectedEndDate: CurrentValueSubject<Date, Never> { get }
}

protocol CreateViewModelIO: CreateViewModelInput, CreateViewModelOutput { }

class CreateViewModel: CreateViewModelIO {
    var createButtonState = CurrentValueSubject<Bool, Never>(false)
    var expectedEndDate = CurrentValueSubject<Date, Never>(Calendar.current.date(byAdding: DateComponents(day: 7), to: Date()) ?? Date())
    var cancellables = Set<AnyCancellable>()
    var createUsecase: ChallengeCreateUsecase

    private var title: String
    private var category: Challenge.Category?
    private var imageURL: String
    private var week: Int
    private var introduction: String
    private var authMethod: String
    private var authExampleImageURL: String

    init(createUsecase: ChallengeCreateUsecase) {
        self.createUsecase = createUsecase
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
        return "\(min(max(week, 0), 53))"
    }

    func update(category: Challenge.Category) {
        self.category = category
        self.validate()
    }

    func update(title: String) {
        self.title = title
        self.validate()
    }

    func update(imageURL: String) {
        self.imageURL = imageURL
        self.validate()
    }

    func update(week: Int) {
        self.week = week
        guard let endDate = createUsecase.endDate(week: week) else { return }
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

    func update(authExampleImageURL: String) {
        self.authExampleImageURL = authExampleImageURL
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
}
