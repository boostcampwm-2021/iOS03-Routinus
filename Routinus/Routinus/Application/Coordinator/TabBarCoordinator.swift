//
//  TabBarCoordinator.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/02.
//

import UIKit

final class TabBarCoordinator: NSObject, RoutinusCoordinator {
    enum TabBarPage {
        case challenge
        case home
        case manage
        case myPage

        func title() -> String {
            switch self {
            case .home:
                return "home".localized
            case .challenge:
                return "challenges".localized
            case .manage:
                return "manage".localized
            case .myPage:
                return "mypage".localized
            }
        }

        func tabBarIndex() -> Int {
            switch self {
            case .home:
                return 0
            case .challenge:
                return 1
            case .manage:
                return 2
            case .myPage:
                return 3
            }
        }

        func tabBarSelectedImage() -> UIImage? {
            switch self {
            case .home:
                return UIImage(systemName: "house")
            case .challenge:
                return UIImage(named: "challenge")
            case .manage:
                return UIImage(systemName: "highlighter")
            case .myPage:
                return UIImage(systemName: "person")
            }
        }
    }

    var childCoordinator: [RoutinusCoordinator] = []
    var navigationController: UINavigationController
    var tabBarController: UITabBarController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.navigationBar.isHidden = true
        self.tabBarController = UITabBarController()
    }

    func start() {
        configureTabBarController()
    }

    private func configureTabBarController() {
        let pages: [TabBarPage] = [.home, .challenge, .manage, .myPage]
        let controllers: [UINavigationController] = pages.map { getTabBarController($0) }
        prepareTabBarController(withTabControllers: controllers)
    }

    private func getTabBarController(_ page: TabBarPage) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.tabBarItem = UITabBarItem.init(
            title: page.title(),
            image: page.tabBarSelectedImage(),
            selectedImage: page.tabBarSelectedImage()
        )

        switch page {
        case .home:
            let homeCoordinator = HomeCoordinator(navigationController: navigationController)
            homeCoordinator.start()
            childCoordinator.append(homeCoordinator)
        case .challenge:
            let challengeCoordinator = ChallengeCoordinator(navigationController: navigationController)
            challengeCoordinator.start()
            childCoordinator.append(challengeCoordinator)
        case .manage:
            let manageCoordinator = ManageCoordinator(navigationController: navigationController)
            manageCoordinator.start()
            childCoordinator.append(manageCoordinator)
        case .myPage:
            let myPageCoordinator = MyPageCoordinator(navigationController: navigationController)
            myPageCoordinator.start()
            childCoordinator.append(myPageCoordinator)
        }

        return navigationController
    }

    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        tabBarController.setViewControllers(tabControllers, animated: true)
        tabBarController.selectedIndex = TabBarPage.home.tabBarIndex()
        tabBarController.tabBar.tintColor = UIColor(named: "MainColor")
        tabBarController.tabBar.backgroundColor = .systemBackground
        tabBarController.tabBar.isTranslucent = false
        navigationController.viewControllers = [tabBarController]
    }
}
