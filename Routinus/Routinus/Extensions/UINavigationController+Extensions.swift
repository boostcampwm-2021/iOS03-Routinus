//
//  UINavigationController+Extensions.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/15.
//

import UIKit

extension UINavigationController {
    enum Direction {
        case left, right
    }
    
    func configureTransition(from direction: Direction) {
        let transition = CATransition()
        transition.duration = 0.35
        transition.type = .push
        transition.subtype = direction == .right ? .fromRight : .fromLeft
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        self.view.window?.layer.add(transition, forKey: kCATransition)
    }
}
