//
//  HomeCoordinator.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/02.
//

import Combine
import UIKit

class HomeCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinator: [Coordinator] = []
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
                let challengeViewController = ChallengeViewController()
                self?.navigationController.pushViewController(challengeViewController, animated: false)
            }
            .store(in: &cancellables)
        
        homeViewModel.showChallengeDetailSignal
            .sink { [weak self] challengeID in
                guard let self = self,
                      let tapBarCoordinator = self.parentCoordinator else { return }
            }
            .store(in: &cancellables)
        
        self.navigationController.pushViewController(homeViewController, animated: false)
    }
}
