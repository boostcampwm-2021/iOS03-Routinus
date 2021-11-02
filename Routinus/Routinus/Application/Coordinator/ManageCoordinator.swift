//
//  ManageCoordinator.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/02.
//

import Foundation
import UIKit

class ManageCoordinator: Coordinator {
    var childCoordinator: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let manageViewController = ManageViewController()
        self.navigationController.pushViewController(manageViewController, animated: false)
    }
}
