//
//  MyPageCoordinator.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/02.
//

import UIKit

final class MyPageCoordinator: RoutinusCoordinator {
    var childCoordinator: [RoutinusCoordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let repository = RoutinusRepository()
        let userFetchUsecase = UserFetchUsecase(repository: repository)
        let myPageViewModel = MyPageViewModel(userFetchUsecase: userFetchUsecase)
        let myPageViewController = MyPageViewController(with: myPageViewModel)

        self.navigationController.pushViewController(myPageViewController, animated: false)
    }
}
