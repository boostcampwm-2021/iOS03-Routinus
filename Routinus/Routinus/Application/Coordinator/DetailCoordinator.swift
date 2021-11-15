//
//  DetailCoordinator.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/07.
//

import UIKit

final class DetailCoordinator: RoutinusCoordinator {
    var childCoordinator: [RoutinusCoordinator] = []
    var navigationController: UINavigationController
    let challengeID: String

    init(navigationController: UINavigationController, challengeID: String) {
        self.navigationController = navigationController
        self.challengeID = challengeID
    }

    func start() {
        let detailViewController = DetailViewController()
        detailViewController.modalPresentationStyle = .fullScreen
        self.navigationController.configureTransition(from: .right)
        self.navigationController.present(detailViewController, animated: false, completion: nil)
    }
}
