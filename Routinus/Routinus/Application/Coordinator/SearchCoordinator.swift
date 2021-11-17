//
//  SearchCoordinator.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/09.
//

import Combine
import UIKit

final class SearchCoordinator: RoutinusCoordinator {
    var childCoordinator: [RoutinusCoordinator] = []
    var navigationController: UINavigationController
    var cancellables = Set<AnyCancellable>()
    var category: Challenge.Category?

    init(navigationController: UINavigationController, category: Challenge.Category? = nil) {
        self.navigationController = navigationController
        self.category = category
    }

    func start() {
        let repository = RoutinusRepository()
        let imageFetchUsecase = ImageFetchUsecase(repository: repository)
        let challengeFetchUsecase = ChallengeFetchUsecase(repository: repository)
        let searchViewModel = SearchViewModel(category: category,
                                              imageFetchusecase: imageFetchUsecase,
                                              challengeFetchUsecase: challengeFetchUsecase)
        let searchViewController = SearchViewController(with: searchViewModel)
        self.navigationController.pushViewController(searchViewController, animated: true)

        searchViewModel.challengeTap
            .sink { [weak self] challengeID in
                guard let self = self else { return }
                let detailCoordinator = DetailCoordinator(
                    navigationController: self.navigationController, challengeID: challengeID
                )
                detailCoordinator.start()
            }
            .store(in: &cancellables)
    }
}
