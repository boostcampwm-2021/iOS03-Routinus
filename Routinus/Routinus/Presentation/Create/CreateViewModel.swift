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
    func update(title: String)
    func update(category: Challenge.Category)
    func update(imageURL: String)
    func update(week: Int)
    func update(introduction: String)
    func update(authMethod: String)
    func update(authExampleImageURL: String)
    func didTappedCreateButton()
}

protocol CreateViewModelOutput {
    var challenge: CurrentValueSubject<Challenge, Never> { get }
    var createButtonState: CurrentValueSubject<Bool, Never> { get }
}

protocol CreateViewModelIO: CreateViewModelInput, CreateViewModelOutput { }

class CreateViewModel: CreateViewModelIO {
    var challenge = CurrentValueSubject<Challenge, Never>(Challenge())
    var createButtonState = CurrentValueSubject<Bool, Never>(false)

    var createUsecase: ChallengeCreateUsecase
    var cancellables = Set<AnyCancellable>()

    init(createUsecase: ChallengeCreateUsecase) {
        self.createUsecase = createUsecase
    }

    func validate() {
        createButtonState.value = !challenge.value.isEmpty()
    }

    func update(title: String) {
        challenge.value.title = title
    }

    func update(category: Challenge.Category) {
        challenge.value.category = category
    }

    func update(imageURL: String) {
        challenge.value.imageURL = imageURL
    }

    func update(week: Int) {
        challenge.value.week = week
    }

    func update(introduction: String) {
        challenge.value.introduction = introduction
    }

    func update(authMethod: String) {
        challenge.value.authMethod = authMethod
    }

    func update(authExampleImageURL: String) {
        challenge.value.authExampleImageURL = authExampleImageURL
    }

    func didTappedCreateButton() {
        createUsecase.createChallenge(challenge: challenge.value)
    }
}
