//
//  UIImageView+Extensions.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/23.
//

import UIKit

extension UIImageView {
    func coverBlurEffect() {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.alpha = 0.9
        self.addSubview(blurEffectView)
    }
}
