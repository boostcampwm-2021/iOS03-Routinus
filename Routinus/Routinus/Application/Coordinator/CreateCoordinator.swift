//
//  CreateCoordinator.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/10.
//

import UIKit

class CreateCoordinator: RoutinusCoordinator {
    var parentCoordinator: RoutinusCoordinator?
    var childCoordinator: [RoutinusCoordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let createRepository = RoutinusRepository()
        let challengeCreateUsecase = ChallengeCreateUsecase(repository: createRepository)
        let createViewModel = CreateViewModel(createUsecase: challengeCreateUsecase)
        let createViewController = CreateViewController(with: createViewModel)
        self.navigationController.pushViewController(createViewController, animated: false)
    }
}
