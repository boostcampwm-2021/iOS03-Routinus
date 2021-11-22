//
//  LaunchVIew.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/22.
//

import UIKit

final class LaunchView: UIView {
    private lazy var launchImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Logo"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override func draw(_ rect: CGRect) {
        self.configureViews()
        self.animation()
    }

    private func configureViews() {
        self.backgroundColor = .white
        self.addSubview(launchImageView)
        self.launchImageView.anchor(leading: self.leadingAnchor, paddingLeading: 30,
                                   trailing: self.trailingAnchor, paddingTrailing: 30,
                                   centerX: self.centerXAnchor,
                                   centerY: self.centerYAnchor)
    }

    private func animation() {
        UIView.animate(withDuration: 2,
                       animations: {
            self.launchImageView.alpha = 0
        },
                       completion: { _ in
            self.removeFromSuperview()
        })
    }
}
