//
//  AuthCoordinator.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/07.
//

import Combine
import UIKit

final class AuthCoordinator: RoutinusCoordinator {
    static let confirmAuth = Notification.Name("confirmAuth")
    var childCoordinator: [RoutinusCoordinator] = []
    var navigationController: UINavigationController
    var cancellables = Set<AnyCancellable>()
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
        let challengeAuthCreateUsecase = ChallengeAuthCreateUsecase(repository: repository)
        let participationUpdateUsecase = ParticipationUpdateUsecase(repository: repository)
        let achievementUpdateUsecase = AchievementUpdateUsecase(repository: repository)
        let userUpdateUsecase = UserUpdateUsecase(repository: repository)
        let userFetchUsecase = UserFetchUsecase(repository: repository)
        let authViewModel = AuthViewModel(challengeID: challengeID,
                                          challengeFetchUsecase: challengeFetchUsecase,
                                          imageFetchUsecase: imageFetchUsecase,
                                          imageSaveUsecase: imageSaveUsecase,
                                          challengeAuthCreateUsecase: challengeAuthCreateUsecase,
                                          participationUpdateUsecase: participationUpdateUsecase,
                                          achievementUpdateUsecase: achievementUpdateUsecase,
                                          userUpdateUsecase: userUpdateUsecase,
                                          userFetchUsecase: userFetchUsecase)
        let authViewController = AuthViewController(viewModel: authViewModel)
        authViewController.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(authViewController, animated: true)

        authViewModel.alertConfirmTap
            .sink { _ in
                NotificationCenter.default.post(name: AuthCoordinator.confirmAuth, object: nil)
            }
            .store(in: &cancellables)

        authViewModel.authMethodImageTap
            .receive(on: RunLoop.main)
            .sink { [weak self] imageData in
                guard let self = self else { return }
                let imageViewController = ImagePinchViewController()
                imageViewController.setImage(data: imageData)
                imageViewController.modalPresentationStyle = .overCurrentContext
                self.navigationController.present(imageViewController, animated: true)
            }
            .store(in: &cancellables)

        authViewModel.authMethodImageLoad
            .receive(on: RunLoop.main)
            .sink { imageData in
                let imageViewController = authViewController.presentedViewController as? ImagePinchViewController
                imageViewController?.setImage(data: imageData)
            }
            .store(in: &cancellables)
    }
}
