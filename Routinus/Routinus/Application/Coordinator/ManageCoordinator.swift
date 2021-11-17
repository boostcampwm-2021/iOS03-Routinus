//
//  ManageCoordinator.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/02.
//

import Combine
import UIKit

final class ManageCoordinator: RoutinusCoordinator {
    var childCoordinator: [RoutinusCoordinator] = []
    var navigationController: UINavigationController
    var cancellables = Set<AnyCancellable>()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let repository = RoutinusRepository()
        let challengeFetchUsecase = ChallengeFetchUsecase(repository: repository)
        let manageViewModel = ManageViewModel(challengeFetchUsecase: challengeFetchUsecase)
        let manageViewController = ManageViewController(with: manageViewModel)

        manageViewModel.challengeTap
            .sink { [weak self] challengeID in
                guard let self = self else { return }
                let detailCoordinator = DetailCoordinator(
                    navigationController: self.navigationController,
                    challengeID: challengeID)
                detailCoordinator.start()
                self.childCoordinator.append(detailCoordinator)
            }
            .store(in: &cancellables)

        manageViewModel.challengeAddButtonTap
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.navigationController.navigationBar.prefersLargeTitles = false
                let createCoordinator = CreateCoordinator(navigationController: self.navigationController)
                createCoordinator.start()
                self.childCoordinator.append(createCoordinator)
            }
            .store(in: &cancellables)

        self.navigationController.pushViewController(manageViewController, animated: false)
    }
}
