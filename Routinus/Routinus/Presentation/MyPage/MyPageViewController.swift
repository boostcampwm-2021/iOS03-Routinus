//
//  MyPageViewController.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/02.
//

import Combine
import UIKit

final class MyPageViewController: UIViewController {
    private lazy var dummyLabel: UILabel = {
        let label = UILabel()
        label.text = "DummyLabel"
        return label
    }()

    private var viewModel: MyPageViewModelIO?

    init(with viewModel: MyPageViewModelIO) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
    }
}

extension MyPageViewController {
    private func configureViews() {
        self.view.backgroundColor = .systemBackground

        self.view.addSubview(dummyLabel)
        dummyLabel.anchor(centerX: dummyLabel.superview?.centerXAnchor,
                          centerY: dummyLabel.superview?.centerYAnchor)
    }
}
