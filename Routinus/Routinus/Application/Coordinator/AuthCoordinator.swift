//
//  AuthCoordinator.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/07.
//

import Combine
import UIKit

final class AuthCoordinator: RoutinusCoordinator {
    var childCoordinator: [RoutinusCoordinator] = []
    var navigationController: UINavigationController
    let challengeID: String
    var cancellables = Set<AnyCancellable>()

    init(navigationController: UINavigationController, challengeID: String) {
        self.navigationController = navigationController
        self.challengeID = challengeID
    }

    func start() {
        let repository = RoutinusRepository()
        let challengeFetchUsecase = ChallengeFetchUsecase(repository: repository)
        let imageFetchUsecase = ImageFetchUsecase(repository: repository)
        let imageSaveUsecase = ImageSaveUsecase(repository: repository)
        let challengeAuthCreateUsecase = ChallengeAuthCreateUsecase(repository: repository)
        let participationUpdateUsecase = ParticipationUpdateUsecase(repository: repository)
        let achievementUpdateUsecase = AchievementUpdateUsecase(repository: repository)
        let authViewModel = AuthViewModel(challengeID: challengeID,
                                          challengeFetchUsecase: challengeFetchUsecase,
                                          imageFetchUsecase: imageFetchUsecase,
                                          imageSaveUsecase: imageSaveUsecase,
                                          challengeAuthCreateUsecase: challengeAuthCreateUsecase,
                                          participationUpdateUsecase: participationUpdateUsecase,
                                          achievementUpdateUsecase: achievementUpdateUsecase)
        let authViewController = AuthViewController(viewModel: authViewModel)
        authViewController.hidesBottomBarWhenPushed = true
        self.navigationController.pushViewController(authViewController, animated: true)
        
        authViewModel.alertConfirmTap
            .sink { _ in
                NotificationCenter.default.post(name: .confirmAuth, object: nil)
            }
            .store(in: &cancellables)
    }
}
