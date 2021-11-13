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
        let repository = RoutinusRepository()
        let challengeCreateUsecase = ChallengeCreateUsecase(repository: repository)
        let challengeUpdateUsecase = ChallengeUpdateUsecase(repository: repository)
        // TODO: - challengeID 주입하기
//        let createViewModel = CreateViewModel(challengeID: <#T##String#>, createUsecase: updateRepository, updateUsecase: <#T##ChallengeUpdatableUsecase#>)
//        let createViewController = CreateViewController(with: createViewModel)
//        self.navigationController.pushViewController(createViewController, animated: false)
    }
}
