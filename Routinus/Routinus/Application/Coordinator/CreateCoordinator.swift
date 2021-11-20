//
//  CreateCoordinator.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/10.
//

import Combine
import UIKit

final class CreateCoordinator: RoutinusCoordinator {
    static let confirmCreate = Notification.Name("confirmCreate")
    var childCoordinator: [RoutinusCoordinator] = []
    var navigationController: UINavigationController
    var cancellables = Set<AnyCancellable>()
    var challengeID: String?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    init(navigationController: UINavigationController, challengeID: String? = nil) {
        self.navigationController = navigationController
        self.challengeID = challengeID
    }

    func start() {
        let repository = RoutinusRepository()
        let challengeCreateUsecase = ChallengeCreateUsecase(repository: repository)
        let challengeUpdateUsecase = ChallengeUpdateUsecase(repository: repository)
        let challengeFetchUsecase = ChallengeFetchUsecase(repository: repository)
        let imageSaveUsecase = ImageSaveUsecase(repository: repository)

        let createViewModel = CreateViewModel(challengeID: challengeID,
                                              challengeCreateUsecase: challengeCreateUsecase,
                                              challengeUpdateUsecase: challengeUpdateUsecase,
                                              challengeFetchUsecase: challengeFetchUsecase,
                                              imageSaveUsecase: imageSaveUsecase)
        let createViewController = CreateViewController(with: createViewModel)
        createViewController.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(createViewController, animated: true)

        createViewModel.alertConfirmTap
            .sink { _ in
                NotificationCenter.default.post(name: CreateCoordinator.confirmCreate, object: nil)
            }
            .store(in: &cancellables)
    }
}
