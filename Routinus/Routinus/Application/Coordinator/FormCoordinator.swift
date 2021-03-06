//
//  FormCoordinator.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/10.
//

import Combine
import UIKit

final class FormCoordinator: RoutinusCoordinator {
    var challengeID: String?
    var childCoordinator: [RoutinusCoordinator] = []
    var navigationController: UINavigationController
    var cancellables = Set<AnyCancellable>()

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
        let imageFetchUsecase = ImageFetchUsecase(repository: repository)
        let imageSaveUsecase = ImageSaveUsecase(repository: repository)
        let imageUpdateUsecase = ImageUpdateUsecase(repository: repository)
        let formViewModel = FormViewModel(challengeID: challengeID,
                                          challengeCreateUsecase: challengeCreateUsecase,
                                          challengeUpdateUsecase: challengeUpdateUsecase,
                                          challengeFetchUsecase: challengeFetchUsecase,
                                          imageFetchUsecase: imageFetchUsecase,
                                          imageSaveUsecase: imageSaveUsecase,
                                          imageUpdateUsecase: imageUpdateUsecase)
        let formViewController = FormViewController(with: formViewModel)

        formViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(formViewController, animated: true)
    }
}
