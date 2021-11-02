//
//  HomeCoordinator.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/02.
//

import Foundation
import UIKit

class HomeCoordinator: Coordinator {
    var childCoordinator: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let homeViewController = HomeViewController()
        self.navigationController.pushViewController(homeViewController, animated: false)
    }
}
