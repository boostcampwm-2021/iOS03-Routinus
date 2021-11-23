//
//  LaunchView.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/22.
//

import UIKit

final class LaunchView: UIView {
    weak var delegate: LaunchViewDelegate?

    private lazy var launchImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Logo"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureViews()
        self.animation()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureViews()
        self.animation()
    }

    convenience init() {
        self.init(frame: CGRect.zero)
    }
}

extension LaunchView {
    private func configureViews() {
        self.backgroundColor = .systemBackground
        self.addSubview(launchImageView)

        self.launchImageView.anchor(leading: self.leadingAnchor, paddingLeading: 30,
                                   trailing: self.trailingAnchor, paddingTrailing: 30,
                                   centerX: self.centerXAnchor,
                                   centerY: self.centerYAnchor)
    }

    private func animation() {
        UIView.animate(withDuration: 0.5,
                       animations: { },
                       completion: { _ in
            self.delegate?.didStartedLaunchView()
            UIView.animate(withDuration: 0.5,
                           animations: {
                self.launchImageView.alpha = 0
            },
                           completion: { _ in
                self.removeFromSuperview()
            })
        })
    }
}

protocol LaunchViewDelegate: AnyObject {
    func didStartedLaunchView()
}
