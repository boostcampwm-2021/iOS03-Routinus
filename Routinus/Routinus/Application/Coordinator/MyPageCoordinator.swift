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
        let myPageViewController = MyPageViewController()
        self.navigationController.pushViewController(myPageViewController, animated: false)
    }
}
