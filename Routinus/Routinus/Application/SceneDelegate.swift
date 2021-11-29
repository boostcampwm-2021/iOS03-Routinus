//
//  SceneDelegate.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/01.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let naviationController = UINavigationController()
        window?.rootViewController = naviationController
        window?.makeKeyAndVisible()
        
        let appCoordinator = AppCoordinator(navigationController: naviationController)
        appCoordinator.start()
        self.appCoordinator = appCoordinator
    }
}
