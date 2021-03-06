//
//  DetailCoordinator.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/07.
//

import Combine
import UIKit

final class DetailCoordinator: RoutinusCoordinator {
    let challengeID: String?
    var childCoordinator: [RoutinusCoordinator] = []
    var navigationController: UINavigationController
    var cancellables = Set<AnyCancellable>()

    init(navigationController: UINavigationController, challengeID: String) {
        self.navigationController = navigationController
        self.challengeID = challengeID
    }

    func start() {
        guard let challengeID = challengeID else { return }
        let repository = RoutinusRepository()
        let challengeFetchUsecase = ChallengeFetchUsecase(repository: repository)
        let challengeUpdateUsecase = ChallengeUpdateUsecase(repository: repository)
        let imageFetchUsecase = ImageFetchUsecase(repository: repository)
        let participationFetchUsecase = ParticipationFetchUsecase(repository: repository)
        let participationCreateUsecase = ParticipationCreateUsecase(repository: repository)
        let userFetchUsecase = UserFetchUsecase(repository: repository)
        let authFetchUsecase = AuthFetchUsecase(repository: repository)
        let achievementUpdateUsecase = AchievementUpdateUsecase(repository: repository)
        let detailViewModel = DetailViewModel(
            challengeID: challengeID,
            challengeFetchUsecase: challengeFetchUsecase,
            challengeUpdateUsecase: challengeUpdateUsecase,
            imageFetchUsecase: imageFetchUsecase,
            participationFetchUsecase: participationFetchUsecase,
            participationCreateUsecase: participationCreateUsecase,
            userFetchUsecase: userFetchUsecase,
            authFetchUsecase: authFetchUsecase,
            achievementUpdateUsecase: achievementUpdateUsecase
        )
        let detailViewController = DetailViewController(with: detailViewModel)

        detailViewModel.editBarButtonTap
            .sink { [weak self] challengeID in
                guard let self = self else { return }
                let formCoordinator = FormCoordinator(
                    navigationController: self.navigationController,
                    challengeID: challengeID
                )
                formCoordinator.start()
                self.childCoordinator.append(formCoordinator)
            }
            .store(in: &cancellables)

        detailViewModel.authButtonTap
            .sink { [ weak self ] challengeID in
                guard let self = self else { return }
                let authCoordinator = AuthCoordinator(
                    navigationController: self.navigationController,
                    challengeID: challengeID
                )
                authCoordinator.start()
                self.childCoordinator.append(authCoordinator)
            }
            .store(in: &cancellables)

        detailViewModel.allAuthDisplayViewTap
            .sink { [weak self] challengeID in
                guard let self = self else { return }
                let authImagesCoordinator = AuthImagesCoordinator(
                    navigationController: self.navigationController,
                    challengeID: challengeID,
                    authDisplayState: .all
                )
                authImagesCoordinator.start()
                self.childCoordinator.append(authImagesCoordinator)
            }
            .store(in: &cancellables)

        detailViewModel.myAuthDisplayViewTap
            .sink { [weak self] challengeID in
                guard let self = self else { return }
                let authImagesCoordinator = AuthImagesCoordinator(
                    navigationController: self.navigationController,
                    challengeID: challengeID,
                    authDisplayState: .my
                )
                authImagesCoordinator.start()
                self.childCoordinator.append(authImagesCoordinator)
            }
            .store(in: &cancellables)

        detailViewModel.authMethodImageTap
            .receive(on: RunLoop.main)
            .sink { [weak self] imageData in
                guard let self = self else { return }
                let imageViewController = ImagePanViewController()
                imageViewController.updateImage(data: imageData)
                imageViewController.modalPresentationStyle = .overCurrentContext
                imageViewController.modalTransitionStyle = .crossDissolve
                self.navigationController.present(imageViewController, animated: true)
            }
            .store(in: &cancellables)

        detailViewModel.authMethodImageLoad
            .receive(on: RunLoop.main)
            .sink { imageData in
                let imageViewController = detailViewController.presentedViewController as? ImagePanViewController
                imageViewController?.updateImage(data: imageData)
            }
            .store(in: &cancellables)

        detailViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(detailViewController, animated: true)
    }
}
