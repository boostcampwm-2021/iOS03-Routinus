//
//  ChallengeCoordinator.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/02.
//

import UIKit

class ChallengeCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var childCoordinator: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let challengeViewController = ChallengeViewController()
        self.navigationController.pushViewController(challengeViewController, animated: false)
    }

    func moveTo(type: ChallegeType, challengeID: String? = nil) {
        switch type {
        case .main:
            resetToRoot()
        case .search:
            resetToRoot()
        case .detail:
            resetToRoot()
            if let challengeID = challengeID {
                let detailCoordinator = DetailCoordinator(
                    navigationController: navigationController,
                    challengeID: challengeID
                )
                detailCoordinator.start()
            }
        case .auth:
            resetToRoot()
            if let challengeID = challengeID {
                let authCoordinator = AuthCoordinator(
                    navigationController: navigationController,
                    challengeID: challengeID
                )
                authCoordinator.start()
            }
        }
    }

    private func resetToRoot() {
        self.navigationController.popToRootViewController(animated: false)
    }
}
