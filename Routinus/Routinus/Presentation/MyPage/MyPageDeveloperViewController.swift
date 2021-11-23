//
//  MyPageDeveloperViewController.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/22.
//

import UIKit

final class MyPageDeveloperViewController: UIViewController {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "개발자 정보"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
    }
}

extension MyPageDeveloperViewController {
    private func configureViews() {
        self.view.backgroundColor = .systemBackground

        view.addSubview(titleLabel)
        titleLabel.anchor(centerX: titleLabel.superview?.centerXAnchor,
                          centerY: titleLabel.superview?.centerYAnchor)
    }
}
