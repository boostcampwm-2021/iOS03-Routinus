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
    var category: Challenge.Category?

    init(navigationController: UINavigationController, category: Challenge.Category? = nil) {
        self.navigationController = navigationController
        self.category = category
    }

    func start() {
        let repository = RoutinusRepository()
        let searchUsecase = SearchFetchUsecase(repository: repository)
        let searchViewModel = SearchViewModel(usecase: searchUsecase)
        let searchViewController = SearchViewController(with: searchViewModel)
        self.navigationController.pushViewController(searchViewController, animated: false)
    }
}
