//
//  CreateCoordinator.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/10.
//

import UIKit

class CreateCoordinator: RoutinusCoordinator {
    var childCoordinator: [RoutinusCoordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let repository = RoutinusRepository()
        let createUsecase = ChallengeCreateUsecase(repository: repository)
        let updateUsecase = ChallengeUpdateUsecase(repository: repository)
        // TODO: - 챌린지 관리 화면으로부터 challengeID 주입받기
        let createViewModel = CreateViewModel(challengeID: "24F3374C-BFA7-49B2-AE26-F887009DC3DA", createUsecase: createUsecase, updateUsecase: updateUsecase)
        let createViewController = CreateViewController(with: createViewModel)
        self.navigationController.pushViewController(createViewController, animated: false)
    }
}
