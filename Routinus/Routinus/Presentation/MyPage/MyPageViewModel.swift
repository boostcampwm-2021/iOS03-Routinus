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
    func updateUsername(_ name: String)
    func updateThemeStyle(_ style: Int)
}

protocol MyPageViewModelOutput {
    var user: CurrentValueSubject<User, Never> { get }
    var themeStyle: CurrentValueSubject<Int, Never> { get }
}

protocol MyPageViewModelIO: MyPageViewModelInput, MyPageViewModelOutput { }

final class MyPageViewModel: MyPageViewModelIO {
    var user = CurrentValueSubject<User, Never>(User())
    var themeStyle = CurrentValueSubject<Int, Never>(0)

    var cancellables = Set<AnyCancellable>()

    var userFetchUsecase: UserFetchableUsecase
    var userUpdateUsecase: UserUpdatableUsecase

    let userCreatePublisher = NotificationCenter.default.publisher(
        for: UserCreateUsecase.didCreateUser,
        object: nil
    )
    let userUpdatePublisher = NotificationCenter.default.publisher(
        for: UserUpdateUsecase.didUpdateUser,
        object: nil
    )

    init(userFetchUsecase: UserFetchableUsecase, userUpdateUsecase: UserUpdatableUsecase) {
        self.userFetchUsecase = userFetchUsecase
        self.userUpdateUsecase = userUpdateUsecase
        configure()
        fetchUser()
        fetchThemeStyle()
    }
}

extension MyPageViewModel {
    private func configure() {
        configurePublishers()
    }

    private func configurePublishers() {
        userCreatePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.fetchUser()
            }
            .store(in: &cancellables)

        userUpdatePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.fetchUser()
            }
            .store(in: &cancellables)
    }
}

extension MyPageViewModel: MyPageViewModelInput {
    func fetchUser() {
        guard let id = userFetchUsecase.fetchUserID() else { return }
        userFetchUsecase.fetchUser(id: id) { [weak self] user in
            guard let self = self else { return }
            self.user.value = user
        }
    }

    func fetchThemeStyle() {
        themeStyle.value = userFetchUsecase.fetchThemeStyle()
    }

    func updateUsername(_ name: String) {
        userUpdateUsecase.updateUsername(of: user.value.id, name: name)
    }

    func updateThemeStyle(_ style: Int) {
        userUpdateUsecase.updateThemeStyle(style)
    }
}
