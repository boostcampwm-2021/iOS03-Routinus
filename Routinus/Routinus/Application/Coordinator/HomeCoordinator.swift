//
//  HomeCoordinator.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/02.
//

import Combine
import UIKit

final class HomeCoordinator: RoutinusCoordinator {
    var childCoordinator: [RoutinusCoordinator] = []
    var navigationController: UINavigationController
    var cancellables = Set<AnyCancellable>()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let repository = RoutinusRepository()
        let userCreateUsecase = UserCreateUsecase(repository: repository)
        let userFetchUsecase = UserFetchUsecase(repository: repository)
        let userUpdateUsecase = UserUpdateUsecase(repository: repository)
        let todayRoutineFetchUsecase = TodayRoutineFetchUsecase(repository: repository)
        let achievementFetchUsecase = AchievementFetchUsecase(repository: repository)
        let authFetchUsecase = AuthFetchUsecase(repository: repository)
        let homeViewModel = HomeViewModel(userCreateUsecase: userCreateUsecase,
                                          userFetchUsecase: userFetchUsecase,
                                          userUpdateUsecase: userUpdateUsecase,
                                          todayRoutineFetchUsecase: todayRoutineFetchUsecase,
                                          achievementFetchUsecase: achievementFetchUsecase,
                                          authFetchUsecase: authFetchUsecase)
        let homeViewController = HomeViewController(with: homeViewModel)

        homeViewModel.challengeAddButtonTap
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.navigationController.tabBarController?.selectedIndex = 1
            }
            .store(in: &cancellables)

        homeViewModel.todayRoutineTap
            .sink { [weak self] challengeID in
                guard let self = self else { return }
                let detailCoordinator = DetailCoordinator.init(
                    navigationController: self.navigationController,
                    challengeID: challengeID
                )
                self.childCoordinator.append(detailCoordinator)
                detailCoordinator.start()
            }
            .store(in: &cancellables)

        homeViewModel.todayRoutineAuthTap
            .sink { [weak self] challengeID in
                guard let self = self else { return }
                let authCoordinator = AuthCoordinator.init(
                    navigationController: self.navigationController,
                    challengeID: challengeID
                )
                self.childCoordinator.append(authCoordinator)
                authCoordinator.start()
            }
            .store(in: &cancellables)

        homeViewModel.calendarExplanationButtonTap
            .sink { _ in
                let viewController = HomeCalendarExplanationViewController()
                viewController.modalPresentationStyle = .overFullScreen
                viewController.modalTransitionStyle = .crossDissolve
                homeViewController.present(viewController, animated: true, completion: nil)
            }
            .store(in: &cancellables)

        homeViewModel.calendarDateTap
            .receive(on: RunLoop.main)
            .sink { (date, challenges) in
                let viewController = HomeCalendarDetailViewController()
                viewController.date = date
                viewController.challenges = challenges
                viewController.modalPresentationStyle = .overFullScreen
                homeViewController.present(viewController, animated: false, completion: nil)
            }
            .store(in: &cancellables)

        navigationController.pushViewController(homeViewController, animated: false)
    }
}
