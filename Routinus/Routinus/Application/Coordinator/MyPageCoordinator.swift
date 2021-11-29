//
//  MyPageCoordinator.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/02.
//

import Combine
import UIKit

final class MyPageCoordinator: RoutinusCoordinator {
    var childCoordinator: [RoutinusCoordinator] = []
    var navigationController: UINavigationController
    var cancellables = Set<AnyCancellable>()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let repository = RoutinusRepository()
        let userFetchUsecase = UserFetchUsecase(repository: repository)
        let userUpdateUsecase = UserUpdateUsecase(repository: repository)
        let myPageViewModel = MyPageViewModel(userFetchUsecase: userFetchUsecase,
                                              userUpdateUsecase: userUpdateUsecase)
        let myPageViewController = MyPageViewController(with: myPageViewModel)

        navigationController.pushViewController(myPageViewController, animated: false)
    }
}
