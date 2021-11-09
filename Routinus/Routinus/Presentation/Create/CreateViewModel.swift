//
//  CreateViewModel.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/09.
//

import Combine
import Foundation

protocol CreateViewModelInput {
    func didTappedCreateButton()
}

protocol CreateViewModelOutput {
    var createChallenge: CurrentValueSubject<CreateChallenge, Never> { get }
    var createButtonState: CurrentValueSubject<Bool, Never> { get }
}

protocol CreateViewModelIO: CreateViewModelInput, CreateViewModelOutput { }

class CreateViewModel: CreateViewModelIO {
    var createChallenge = CurrentValueSubject<CreateChallenge, Never>(CreateChallenge()) {
        didSet {
            validate()
        }
    }

    var createButtonState = CurrentValueSubject<Bool, Never>(false)

    func validate() {
        createButtonState.value = !createChallenge.value.isEmpty()
    }

    func didTappedCreateButton() {
        // TODO: firebase에 저장
    }
}




