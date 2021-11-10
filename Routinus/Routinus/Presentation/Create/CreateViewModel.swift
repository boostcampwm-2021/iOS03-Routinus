//
//  CreateViewModel.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/09.
//

import Combine
import Foundation

protocol CreateViewModelInput {
    func validate()
    func update(category: Challenge.Category)
    func update(title: String)
    func update(imageURL: String)
    func update(week: Int)
    func update(introduction: String)
    func update(authMethod: String)
    func update(authExampleImageURL: String)
    func didTappedCreateButton()
}

protocol CreateViewModelOutput {
    var createButtonState: CurrentValueSubject<Bool, Never> { get }
}

protocol CreateViewModelIO: CreateViewModelInput, CreateViewModelOutput { }

class CreateViewModel: CreateViewModelIO {
    var createButtonState = CurrentValueSubject<Bool, Never>(false)
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
        title = ""
        imageURL = ""
        week = 0
        introduction = ""
        authMethod = ""
        authExampleImageURL = ""
    }

    func validate() {
        createButtonState.value = !createUsecase.isEmpty(title: title,
                                                         imageURL: imageURL,
                                                         introduction: introduction,
                                                         authMethod: authMethod,
                                                         authExampleImageURL: authExampleImageURL)
    }

    func update(category: Challenge.Category) {
        self.category = category
    }

    func update(title: String) {
        self.title = title
    }

    func update(imageURL: String) {
        self.imageURL = imageURL
    }

    func update(week: Int) {
        self.week = week
    }

    func update(introduction: String) {
        self.introduction = introduction
    }

    func update(authMethod: String) {
        self.authMethod = authMethod
    }

    func update(authExampleImageURL: String) {
        self.authExampleImageURL = authExampleImageURL
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
