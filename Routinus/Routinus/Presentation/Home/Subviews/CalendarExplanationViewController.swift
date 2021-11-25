//
//  CalendarExplanationViewController.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/25.
//

import UIKit

class CalendarExplanationViewController: UIViewController {
    private lazy var popUpView: UIView = {
        var view = UIView()
        view.backgroundColor = .systemBackground
        view.anchor(width: 200, height: 200)
        return view
    }()

    private lazy var dismissButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = UIColor(named: "Black")
        button.addTarget(self, action: #selector(didTapDismisButton(_:)), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()

    }

    private func configureViews() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        view.addSubview(popUpView)
        popUpView.anchor(centerX: view.centerXAnchor,
                         centerY: view.centerYAnchor)
        popUpView.addSubview(dismissButton)
        dismissButton.anchor(trailing: popUpView.trailingAnchor,
                             paddingTrailing: 10,
                             top: popUpView.topAnchor,
                             paddingTop: 10)
    }

    @objc private func didTapDismisButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
