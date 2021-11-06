//
//  Coordinator.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/02.
//

import UIKit

protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator?
    var childCoordinator: [Coordinator] { get set }
    var navigationController: UINavigationController { get }

    func start()
}
