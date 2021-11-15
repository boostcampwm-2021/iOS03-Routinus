//
//  RoutinusCoordinator.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/02.
//

import UIKit

protocol RoutinusCoordinator: AnyObject {
    var childCoordinator: [RoutinusCoordinator] { get set }
    var navigationController: UINavigationController { get }

    func start()
}
