//
//  AuthsCoordinator.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/23.
//

import Combine
import UIKit

final class AuthsCoordinator: RoutinusCoordinator {
    var childCoordinator: [RoutinusCoordinator] = []
    var navigationController: UINavigationController
    var cancellables = Set<AnyCancellable>()
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

        authImagesViewModel.authImageTap
            .receive(on: RunLoop.main)
            .sink { [weak self] imageData in
                guard let self = self else { return }

                let imageViewController = ImagePinchViewController()
                imageViewController.setImage(data: imageData)
                imageViewController.modalPresentationStyle = .overCurrentContext
                imageViewController.modalTransitionStyle = .crossDissolve
                self.navigationController.present(imageViewController, animated: true)
            }
            .store(in: &cancellables)

        authImagesViewModel.authImageLoad
            .receive(on: RunLoop.main)
            .sink { imageData in
                let imageViewController = authImagesViewController.presentedViewController as? ImagePinchViewController
                imageViewController?.setImage(data: imageData)
            }
            .store(in: &cancellables)
    }
}
