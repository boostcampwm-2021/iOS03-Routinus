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
    let authDisplayState: AuthDisplayState

    init(navigationController: UINavigationController, challengeID: String, authDisplayState: AuthDisplayState) {
        self.navigationController = navigationController
        self.challengeID = challengeID
        self.authDisplayState = authDisplayState
    }

    func start() {
        let repository = RoutinusRepository()
        let challengeAuthFetchUsecase = ChallengeAuthFetchUsecase(repository: repository)
        let imageFetchUsecase = ImageFetchUsecase(repository: repository)
        let authImagesViewModel = AuthImagesViewModel(challengeID: challengeID,
                                                      authDisplayState: authDisplayState,
                                                      challengeAuthFetchUsecase: challengeAuthFetchUsecase,
                                                      imageFetchUsecase: imageFetchUsecase)
        let authImagesViewController = AuthImagesViewController(viewModel: authImagesViewModel)
        self.navigationController.pushViewController(authImagesViewController, animated: true)
    }
}
