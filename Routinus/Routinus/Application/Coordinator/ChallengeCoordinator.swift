//
//  ChallengeCoordinator.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/02.
//

import Combine
import UIKit

final class ChallengeCoordinator: RoutinusCoordinator {
    var childCoordinator: [RoutinusCoordinator] = []
    var navigationController: UINavigationController
    var cancellables = Set<AnyCancellable>()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let repository = RoutinusRepository()
        let challengeUsecase = ChallengeFetchUsecase(repository: repository)
        let challengeViewModel = ChallengeViewModel(usecase: challengeUsecase)
        let challengeViewController = ChallengeViewController(with: challengeViewModel)
        challengeViewModel.searchButtonTap
            .sink { [weak self] _ in
                guard let self = self else { return }
                let searchCoordinator = SearchCoordinator(navigationController: self.navigationController)
                searchCoordinator.start()
                self.childCoordinator.append(searchCoordinator)
            }
            .store(in: &cancellables)
        
        challengeViewModel.seeAllButtonTap
            .sink { [weak self] _ in
                guard let self = self else { return }
                let searchCoordinator = SearchCoordinator(navigationController: self.navigationController)
                searchCoordinator.start()
                self.childCoordinator.append(searchCoordinator)
            }
            .store(in: &cancellables)

        challengeViewModel.recommendChallengeTap
            .sink { [weak self] challengeID in
                guard let self = self else { return }
                let detailCoordinator = DetailCoordinator(navigationController: self.navigationController,
                                                          challengeID: challengeID)
                detailCoordinator.start()
                self.childCoordinator.append(detailCoordinator)
            }
            .store(in: &cancellables)

        challengeViewModel.categoryButtonTap
            .sink { [weak self] category in
                guard let self = self else { return }
                let searchCoordinator = SearchCoordinator(navigationController: self.navigationController,
                                                          category: category)
                searchCoordinator.start()
                self.childCoordinator.append(searchCoordinator)
            }
            .store(in: &cancellables)

        self.navigationController.pushViewController(challengeViewController, animated: false)
    }

    private func resetToRoot() {
        self.navigationController.popToRootViewController(animated: false)
    }
}
