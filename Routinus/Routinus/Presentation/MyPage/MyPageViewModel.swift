//
//  MyPageViewModel.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/22.
//

import Combine
import Foundation

protocol MyPageViewModelInput {
    func fetchUserData()
}

protocol MyPageViewModelOutput {
    var user: CurrentValueSubject<User, Never> { get }
}

protocol MyPageViewModelIO: MyPageViewModelInput, MyPageViewModelOutput { }

final class MyPageViewModel: MyPageViewModelIO {
    var user = CurrentValueSubject<User, Never>(User())

    var userFetchUsecase: UserFetchableUsecase

    init(userFetchUsecase: UserFetchableUsecase) {
        self.userFetchUsecase = userFetchUsecase
        fetchUserData()
    }
}

extension MyPageViewModel {
    func fetchUserData() {
        userFetchUsecase.fetchUser { [weak self] user in
            self?.user.value = user
        }
    }
}
