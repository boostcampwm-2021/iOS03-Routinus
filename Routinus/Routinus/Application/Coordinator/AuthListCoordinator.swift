//
//  AuthListCoordinator.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/23.
//

import UIKit

final class AuthListCoordinator: RoutinusCoordinator {
    var childCoordinator: [RoutinusCoordinator] = []
    var navigationController: UINavigationController
    let challengeID: String

    init(navigationController: UINavigationController, challengeID: String) {
        self.navigationController = navigationController
        self.challengeID = challengeID
    }

    func start() {
        // TODO: Coordinator 작업
    }
}
