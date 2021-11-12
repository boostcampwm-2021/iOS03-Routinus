//
//  DetailCoordinator.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/07.
//

import UIKit

class DetailCoordinator: RoutinusCoordinator {
    var parentCoordinator: RoutinusCoordinator?
    var childCoordinator: [RoutinusCoordinator] = []
    var navigationController: UINavigationController
    let challengeID: String

    init(navigationController: UINavigationController, challengeID: String) {
        self.navigationController = navigationController
        self.challengeID = challengeID
    }

    func start() {
        let detailViewController = DetailViewController()
        detailViewController.modalPresentationStyle = .fullScreen
        let transition = CATransition()
        transition.duration = 0.35
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.navigationController.view.window?.layer.add(transition, forKey: kCATransition)
        self.navigationController.present(detailViewController, animated: false, completion: nil)
    }
}
