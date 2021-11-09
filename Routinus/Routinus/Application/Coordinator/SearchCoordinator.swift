//
//  SearchCoordinator.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/09.
//

import UIKit

class SearchCoordinator: RoutinusCoordinator {
    var parentCoordinator: RoutinusCoordinator?
    var childCoordinator: [RoutinusCoordinator] = []
    var navigationController: UINavigationController
    var category: Category?

    init(navigationController: UINavigationController, category: Category? = nil) {
        self.navigationController = navigationController
        self.category = category
    }

    func start() {
        let searchViewController = SearchViewController()
        self.navigationController.pushViewController(searchViewController, animated: false)
    }
}
