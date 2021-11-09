//
//  CreateViewModel.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/09.
//

import Combine
import Foundation

protocol CreateViewModelInput {
    func didTappedCreateButton(category: String, title: String, thumbImageURL: String, week: String, description: String, authMethod: String, authImageURL: String)
}

protocol CreateViewModelOutput {
    var createState: CurrentValueSubject<Bool, Never> { get }
}

protocol CreateViewModelIO: CreateViewModelInput, CreateViewModelOutput { }

class CreateViewModel: CreateViewModelIO {
    var createState = CurrentValueSubject<Bool, Never>(false)

    func didTappedCreateButton(category: String, title: String, thumbImageURL: String, week: String, description: String, authMethod: String, authImageURL: String) {
        guard !category.isEmpty && !title.isEmpty && !thumbImageURL.isEmpty && !week.isEmpty && !description.isEmpty && !authMethod.isEmpty && !authImageURL.isEmpty else {
            createState.value = false
            return
        }

        // TODO: firebase에 저장
        createState.value = true
    }
}
