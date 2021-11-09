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
    func update(category: String)
    func update(imageURL: String)
    func update(week: Int)
    func update(description: String)
    func update(authMethod: String)
    func update(authImageURL: String)
    func didTappedCreateButton()
}

protocol CreateViewModelOutput {
    var createChallenge: CurrentValueSubject<CreateChallenge, Never> { get }
    var createButtonState: CurrentValueSubject<Bool, Never> { get }
}

protocol CreateViewModelIO: CreateViewModelInput, CreateViewModelOutput { }

class CreateViewModel: CreateViewModelIO {
    var createChallenge = CurrentValueSubject<CreateChallenge, Never>(CreateChallenge())
    var createButtonState = CurrentValueSubject<Bool, Never>(false)

    func validate() {
        createButtonState.value = !createChallenge.value.isEmpty()
    }

    func update(category: String) {
        createChallenge.value.category = category
    }

    func update(imageURL: String) {
        createChallenge.value.imageURL = imageURL
    }

    func update(week: Int) {
        createChallenge.value.week = week
    }

    func update(description: String) {
        createChallenge.value.description = description
    }

    func update(authMethod: String) {
        createChallenge.value.authMethod = authMethod
    }

    func update(authImageURL: String) {
        createChallenge.value.authImageURL = authImageURL
    }

    func didTappedCreateButton() {
        // TODO: firebase에 저장
    }
}
