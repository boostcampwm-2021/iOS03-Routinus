//
//  HomeCoordinator.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/02.
//

import Combine
import UIKit

class HomeCoordinator: RoutinusCoordinator {
    var childCoordinator: [RoutinusCoordinator] = []
    var navigationController: UINavigationController
    var cancellables = Set<AnyCancellable>()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let homeRepository = RoutinusRepository()
        let homeCreateUsecase = HomeCreateUsecase(repository: homeRepository)
        let homeFetchUsecase = HomeFetchUsecase(repository: homeRepository)
        let homeViewModel = HomeViewModel(createUsecase: homeCreateUsecase, fetchUsecase: homeFetchUsecase)
        let homeViewController = HomeViewController(with: homeViewModel)

        homeViewModel.showChallengeSignal
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.navigationController.tabBarController?.selectedIndex = 1
            }
            .store(in: &cancellables)

        homeViewModel.showChallengeDetailSignal
            .sink { [weak self] challengeID in
                guard let self = self else { return }
                let detailCoordinator = DetailCoordinator.init(navigationController: self.navigationController,
                                                               challengeID: challengeID)
                detailCoordinator.start()
            }
            .store(in: &cancellables)

        homeViewModel.showChallengeAuthSignal
            .sink { [weak self] challengeID in
                guard let self = self else { return }
                let authCoordinator = AuthCoordinator.init(navigationController: self.navigationController,
                                                           challengeID: challengeID)
                authCoordinator.start()
            }
            .store(in: &cancellables)

        self.navigationController.pushViewController(homeViewController, animated: false)
    }
}
