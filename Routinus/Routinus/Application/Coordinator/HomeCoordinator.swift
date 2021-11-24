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
    let authPublisher = NotificationCenter.default.publisher(for: AuthCoordinator.confirmAuth,
                                                             object: nil)
    let participationPublisher = NotificationCenter.default.publisher(for: DetailCoordinator.confirmParticipation,
                                                                      object: nil)
    let createPublisher = NotificationCenter.default.publisher(for: CreateCoordinator.confirmCreate,
                                                               object: nil)
    let usernamePublisher = NotificationCenter.default.publisher(for: UserUpdateUsecase.didUpdateUsername,
                                                                 object: nil)

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
        let challengeAuthFetchUsecase = ChallengeAuthFetchUsecase(repository: repository)
        let homeViewModel = HomeViewModel(userCreateUsecase: userCreateUsecase,
                                          userFetchUsecase: userFetchUsecase,
                                          userUpdateUsecase: userUpdateUsecase,
                                          todayRoutineFetchUsecase: todayRoutineFetchUsecase,
                                          achievementFetchUsecase: achievementFetchUsecase,
                                          challengeAuthFetchUsecase: challengeAuthFetchUsecase)
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
                let detailCoordinator = DetailCoordinator.init(navigationController: self.navigationController,
                                                               challengeID: challengeID)
                self.childCoordinator.append(detailCoordinator)
                detailCoordinator.start()
            }
            .store(in: &cancellables)

        homeViewModel.todayRoutineAuthTap
            .sink { [weak self] challengeID in
                guard let self = self else { return }
                let authCoordinator = AuthCoordinator.init(navigationController: self.navigationController,
                                                           challengeID: challengeID)
                self.childCoordinator.append(authCoordinator)
                authCoordinator.start()
            }
            .store(in: &cancellables)

        self.authPublisher
            .receive(on: RunLoop.main)
            .sink { _ in
                homeViewModel.fetchMyHomeData()
            }
            .store(in: &cancellables)

        self.participationPublisher
            .receive(on: RunLoop.main)
            .sink { _ in
                homeViewModel.fetchMyHomeData()
            }
            .store(in: &cancellables)

        self.createPublisher
            .receive(on: RunLoop.main)
            .sink { _ in
                homeViewModel.fetchMyHomeData()
            }
            .store(in: &cancellables)

        self.usernamePublisher
            .receive(on: RunLoop.main)
            .sink { _ in
                homeViewModel.addRefreshIndicator()
            }
            .store(in: &cancellables)

        self.navigationController.pushViewController(homeViewController, animated: false)
    }
}
