//
//  MyPageViewModel.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/22.
//

import Combine
import Foundation

protocol MyPageViewModelInput {
    func fetchUser()
    func fetchThemeStyle()
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
    var cancellables = Set<AnyCancellable>()

    var userFetchUsecase: UserFetchableUsecase
    var userUpdateUsecase: UserUpdatableUsecase

    let userCreatePublisher = NotificationCenter.default.publisher(for: UserCreateUsecase.didCreateUser,
                                                                   object: nil)
    let userUpdatePublisher = NotificationCenter.default.publisher(for: UserUpdateUsecase.didUpdateUser,
                                                                   object: nil)

    init(userFetchUsecase: UserFetchableUsecase,
         userUpdateUsecase: UserUpdatableUsecase) {
        self.userFetchUsecase = userFetchUsecase
        self.userUpdateUsecase = userUpdateUsecase
        fetchUser()
        fetchThemeStyle()
        configurePublishers()
    }
}

extension MyPageViewModel {
    func configurePublishers() {
        self.userCreatePublisher
            .receive(on: RunLoop.main)
            .sink { _ in
                self.fetchUser()
            }
            .store(in: &cancellables)

        self.userUpdatePublisher
            .receive(on: RunLoop.main)
            .sink { _ in
                self.fetchUser()
            }
            .store(in: &cancellables)
    }

    func fetchUser() {
        guard let id = userFetchUsecase.fetchUserID() else { return }
        userFetchUsecase.fetchUser(id: id) { [weak self] user in
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
