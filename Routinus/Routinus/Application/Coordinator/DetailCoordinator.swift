//
//  DetailCoordinator.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/07.
//

import Combine
import UIKit

final class DetailCoordinator: RoutinusCoordinator {
    var childCoordinator: [RoutinusCoordinator] = []
    var navigationController: UINavigationController
    var cancellables = Set<AnyCancellable>()
    let challengeID: String?

    init(navigationController: UINavigationController, challengeID: String) {
        self.navigationController = navigationController
        self.challengeID = challengeID
    }

    func start() {
        guard let challengeID = challengeID else { return }

        let repository = RoutinusRepository()
        let challengeFetchUsecase = ChallengeFetchUsecase(repository: repository)
        let imageFetchUsecase = ImageFetchUsecase(repository: repository)
        let detailViewModel = DetailViewModel(challengeID: challengeID, challengeFetchUsecase: challengeFetchUsecase, imageFetchUsecase: imageFetchUsecase)
        let detailViewController = DetailViewController(with: detailViewModel)
        self.navigationController.pushViewController(detailViewController, animated: true)

        detailViewModel.editBarButtonTap
            .sink { [weak self] challengeID  in
                guard let self = self else { return }
                let createCoordinator = CreateCoordinator(navigationController: self.navigationController, challengeID: challengeID)
                createCoordinator.start()
            }
            .store(in: &cancellables)
    }
}
