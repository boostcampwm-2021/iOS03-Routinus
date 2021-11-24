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
        let repository = RoutinusRepository()
        let challengeAuthFetchUpsecase = ChallengeAuthFetchUsecase(repository: repository)
        let authListViewModel = AuthListViewModel(challengeID: challengeID,
                                                  challengeAuthFetchUsecase: challengeAuthFetchUpsecase)
        let authListViewController = AuthListViewController(viewModel: authListViewModel)
        self.navigationController.pushViewController(authListViewController, animated: true)
    }
}
