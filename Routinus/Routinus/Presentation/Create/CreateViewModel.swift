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
    func update(category: String)
    func update(imageURL: String)
    func update(week: Int)
    func update(description: String)
    func update(authMethod: String)
    func update(authImageURL: String)
    func didTappedCreateButton()
}

protocol CreateViewModelOutput {
    var challenge: CurrentValueSubject<CreateChallenge, Never> { get }
    var createButtonState: CurrentValueSubject<Bool, Never> { get }
}

protocol CreateViewModelIO: CreateViewModelInput, CreateViewModelOutput { }

class CreateViewModel: CreateViewModelIO {
    var challenge = CurrentValueSubject<CreateChallenge, Never>(CreateChallenge())
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

    func update(category: String) {
        challenge.value.category = category
    }

    func update(imageURL: String) {
        challenge.value.imageURL = imageURL
    }

    func update(week: Int) {
        challenge.value.week = week
    }

    func update(description: String) {
        challenge.value.description = description
    }

    func update(authMethod: String) {
        challenge.value.authMethod = authMethod
    }

    func update(authImageURL: String) {
        challenge.value.authImageURL = authImageURL
    }

    func didTappedCreateButton() {
        createUsecase.createChallenge(challenge: challenge.value)
    }
}
