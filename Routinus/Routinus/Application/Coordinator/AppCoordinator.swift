//
//  AppCoordinator.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/02.
//

import UIKit

final class AppCoordinator: RoutinusCoordinator {
    var childCoordinator: [RoutinusCoordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        configureNavigationController()
    }

    func start() {
        configureTabBar()
    }

    private func configureNavigationController() {
        navigationController.navigationBar.isHidden = true
    }

    private func configureTabBar() {
        let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController)
        tabBarCoordinator.start()
        childCoordinator.append(tabBarCoordinator)
    }
}
