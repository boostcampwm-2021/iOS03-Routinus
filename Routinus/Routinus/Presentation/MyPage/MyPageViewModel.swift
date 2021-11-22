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
    var themeStyle: CurrentValueSubject<Int, Never> { get }

    func updateUsername(_ name: String)
    func updateThemeStyle(_ style: Int)
}

protocol MyPageViewModelIO: MyPageViewModelInput, MyPageViewModelOutput { }

final class MyPageViewModel: MyPageViewModelIO {
    var user = CurrentValueSubject<User, Never>(User())
    var themeStyle = CurrentValueSubject<Int, Never>(0)

    var userFetchUsecase: UserFetchableUsecase
    var userUpdateUsecase: UserUpdatableUsecase

    init(userFetchUsecase: UserFetchableUsecase,
         userUpdateUsecase: UserUpdatableUsecase) {
        self.userFetchUsecase = userFetchUsecase
        self.userUpdateUsecase = userUpdateUsecase
        fetchUserData()
        fetchThemeStyle()
    }
}

extension MyPageViewModel {
    func fetchUserData() {
        userFetchUsecase.fetchUser { [weak self] user in
            self?.user.value = user
        }
    }

    func fetchThemeStyle() {
        self.themeStyle.value = userFetchUsecase.fetchThemeStyle()
    }

    func updateUsername(_ name: String) {
        userUpdateUsecase.updateUsername(of: user.value.id,
                                         name: name)
    }

    func updateThemeStyle(_ style: Int) {
        userUpdateUsecase.updateThemeStyle(style)
    }
}
