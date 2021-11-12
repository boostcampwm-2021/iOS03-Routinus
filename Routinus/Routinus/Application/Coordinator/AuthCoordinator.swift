//
//  AuthCoordinator.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/07.
//

import UIKit

class AuthCoordinator: RoutinusCoordinator {
    var parentCoordinator: RoutinusCoordinator?
    var childCoordinator: [RoutinusCoordinator] = []
    var navigationController: UINavigationController
    let challengeID: String

    init(navigationController: UINavigationController, challengeID: String) {
        self.navigationController = navigationController
        self.challengeID = challengeID
    }

    func start() {
        let authViewController = AuthViewController()
        self.navigationController.present(authViewController, animated: true)
    }
}
