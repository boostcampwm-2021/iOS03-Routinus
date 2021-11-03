//
//  AppCoordinator.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/02.
//

import UIKit

class AppCoordinator: Coordinator {
    var childCoordinator: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        configureNavigationController()
    }

    func start() {
        configureTabBar()
    }

    private func configureNavigationController() {
        self.navigationController.setNavigationBarHidden(true, animated: false)
    }

    private func configureTabBar() {
        let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController)
        tabBarCoordinator.start()
        self.childCoordinator.append(tabBarCoordinator)
    }
}
