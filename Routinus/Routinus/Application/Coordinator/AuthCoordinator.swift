//
//  AuthCoordinator.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/07.
//

import Combine
import UIKit

final class AuthCoordinator: RoutinusCoordinator {
    let challengeID: String
    var childCoordinator: [RoutinusCoordinator] = []
    var navigationController: UINavigationController
    var cancellables = Set<AnyCancellable>()

    init(navigationController: UINavigationController, challengeID: String) {
        self.navigationController = navigationController
        self.challengeID = challengeID
    }

    func start() {
        let repository = RoutinusRepository()
        let challengeFetchUsecase = ChallengeFetchUsecase(repository: repository)
        let imageFetchUsecase = ImageFetchUsecase(repository: repository)
        let imageSaveUsecase = ImageSaveUsecase(repository: repository)
        let authCreateUsecase = AuthCreateUsecase(repository: repository)
        let participationUpdateUsecase = ParticipationUpdateUsecase(repository: repository)
        let achievementUpdateUsecase = AchievementUpdateUsecase(repository: repository)
        let userUpdateUsecase = UserUpdateUsecase(repository: repository)
        let userFetchUsecase = UserFetchUsecase(repository: repository)
        let authViewModel = AuthViewModel(challengeID: challengeID,
                                          challengeFetchUsecase: challengeFetchUsecase,
                                          imageFetchUsecase: imageFetchUsecase,
                                          imageSaveUsecase: imageSaveUsecase,
                                          authCreateUsecase: authCreateUsecase,
                                          participationUpdateUsecase: participationUpdateUsecase,
                                          achievementUpdateUsecase: achievementUpdateUsecase,
                                          userUpdateUsecase: userUpdateUsecase,
                                          userFetchUsecase: userFetchUsecase)
        let authViewController = AuthViewController(viewModel: authViewModel)

        authViewModel.authMethodImageTap
            .receive(on: RunLoop.main)
            .sink { [weak self] imageData in
                guard let self = self else { return }
                let imageViewController = ImagePanViewController()
                imageViewController.updateImage(data: imageData)
                imageViewController.modalPresentationStyle = .overCurrentContext
                imageViewController.modalTransitionStyle = .crossDissolve
                self.navigationController.present(imageViewController, animated: true)
            }
            .store(in: &cancellables)

        authViewModel.authMethodImageLoad
            .receive(on: RunLoop.main)
            .sink { imageData in
                let imageViewController = authViewController.presentedViewController as? ImagePanViewController
                imageViewController?.updateImage(data: imageData)
            }
            .store(in: &cancellables)

        authViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(authViewController, animated: true)
    }
}
