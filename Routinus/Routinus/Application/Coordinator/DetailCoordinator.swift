//
//  DetailCoordinator.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/07.
//

import UIKit

class DetailCoordinator: RoutinusCoordinator {
    var parentCoordinator: RoutinusCoordinator?
    var childCoordinator: [RoutinusCoordinator] = []
    var navigationController: UINavigationController
    let challengeID: String

    init(navigationController: UINavigationController, challengeID: String) {
        self.navigationController = navigationController
        self.challengeID = challengeID
    }

    func start() {
        let detailViewController = DetailViewController()
        self.navigationController.pushViewController(detailViewController, animated: false)
    }
}
