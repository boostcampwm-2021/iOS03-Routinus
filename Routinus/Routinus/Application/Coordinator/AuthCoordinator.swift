//
//  AuthCoordinator.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/07.
//

import UIKit

final class AuthCoordinator: RoutinusCoordinator {
    var childCoordinator: [RoutinusCoordinator] = []
    var navigationController: UINavigationController
    let challengeID: String

    init(navigationController: UINavigationController, challengeID: String) {
        self.navigationController = navigationController
        self.challengeID = challengeID
    }

    func start() {
        let repository = RoutinusRepository()
        let challengeFetchUsecase = ChallengeFetchUsecase(repository: repository)
        let imageFetchUsecase = ImageFetchUsecase(repository: repository)
        let imageSaveUsecase = ImageSaveUsecase(repository: repository)
        let authViewModel = AuthViewModel(challengeID: challengeID,
                                          challengeFetchUsecase: challengeFetchUsecase,
                                          imageFetchUsecase: imageFetchUsecase,
                                          imageSaveUsecase: imageSaveUsecase)
        let authViewController = AuthViewController(viewModel: authViewModel)
        authViewController.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(authViewController, animated: true)
    }
}
