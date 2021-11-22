//
//  LaunchViewController.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/22.
//

import UIKit

class LaunchViewController: UIViewController {

    private lazy var lauchImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Logo"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViews()
    }

    func configureViews() {
        self.view.addSubview(lauchImageView)
        self.lauchImageView.anchor(centerX: self.view.centerXAnchor,
                                   centerY: self.view.centerYAnchor)
    }
}
