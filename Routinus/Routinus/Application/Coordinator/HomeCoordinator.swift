//
//  HomeCoordinator.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/02.
//

import Combine
import UIKit

class HomeCoordinator: RoutinusCoordinator {
    var parentCoordinator: RoutinusCoordinator?
    var childCoordinator: [RoutinusCoordinator] = []
    var navigationController: UINavigationController
    var cancellables = Set<AnyCancellable>()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let homeViewModel = HomeViewModel(usecase: HomeFetchUsecase())
        let homeViewController = HomeViewController(with: homeViewModel)
        homeViewModel.showChallengeSignal
            .sink { [weak self] _ in
                guard let self = self,
                      let tapBarCoordinator = self.parentCoordinator as? TabBarCoordinator else { return }
                tapBarCoordinator.moveToChallegeType(type: .main)
            }
            .store(in: &cancellables)

        homeViewModel.showChallengeDetailSignal
            .sink { [weak self] challengeID in
                guard let self = self,
                      let tapBarCoordinator = self.parentCoordinator as? TabBarCoordinator else { return }
                tapBarCoordinator.moveToChallegeType(type: .detail, challengeID: challengeID)
            }
            .store(in: &cancellables)
        
        homeViewModel.showChallengeAuthSignal
            .sink { [weak self] challengeID in
                guard let self = self,
                      let tapBarCoordinator = self.parentCoordinator as? TabBarCoordinator else { return }
                tapBarCoordinator.moveToChallegeType(type: .auth, challengeID: challengeID)
            }
            .store(in: &cancellables)

        self.navigationController.pushViewController(homeViewController, animated: false)
    }
}
