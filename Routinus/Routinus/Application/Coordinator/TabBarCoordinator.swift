//
//  TabBarCoordinator.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/02.
//

import UIKit

class TabBarCoordinator: NSObject, Coordinator {
    var childCoordinator: [Coordinator] = []
    var navigationController: UINavigationController
    var tabBarController: UITabBarController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
        self.navigationController.navigationBar.isHidden = true
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
        navigationController.tabBarItem = UITabBarItem.init(title: nil,
                                                            image: page.tabBarSelectedImage(),
                                                            selectedImage: page.tabBarUnSelectedImage())

        switch page {
        case .home:
            let homeCoordinator = HomeCoordinator(navigationController: navigationController)
            homeCoordinator.start()
            self.childCoordinator.append(homeCoordinator)
        case .challenge:
            let challengeCoordinator = ChallengeCoordinator(navigationController: navigationController)
            challengeCoordinator.start()
            self.childCoordinator.append(challengeCoordinator)
        case .manage:
            let manageCoordinator = ManageCoordinator(navigationController: navigationController)
            manageCoordinator.start()
            self.childCoordinator.append(manageCoordinator)
        case .myPage:
            let myPageCoordinator = MyPageCoordinator(navigationController: navigationController)
            myPageCoordinator.start()
            self.childCoordinator.append(myPageCoordinator)
        }

        return navigationController
    }

    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        tabBarController.setViewControllers(tabControllers, animated: true)
        tabBarController.selectedIndex = TabBarPage.home.tabBarIndex()
        tabBarController.tabBar.tintColor = .systemGray
        tabBarController.tabBar.backgroundColor = .white
        tabBarController.tabBar.isTranslucent = false
        navigationController.viewControllers = [tabBarController]
    }
}

enum TabBarPage {
    case challenge
    case home
    case manage
    case myPage

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
            return UIImage(systemName: "chart.bar")
        case .challenge:
            return UIImage(systemName: "square.grid.2x2")
        case .manage:
            return UIImage(systemName: "highlighter")
        case .myPage:
            return UIImage(systemName: "person")
        }
    }

    func tabBarUnSelectedImage() -> UIImage? {
        switch self {
        case .home:
            return UIImage(systemName: "chart.bar.fill")
        case .challenge:
            return UIImage(systemName: "square.grid.2x2.fill")
        case .manage:
            return UIImage(systemName: "highlighter")
        case .myPage:
            return UIImage(systemName: "person.fill")
        }
    }
}
