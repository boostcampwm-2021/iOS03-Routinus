//
//  CalendarExplanationViewController.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/25.
//

import UIKit

class CalendarExplanationViewController: UIViewController {
    enum StickerPercent: String, CaseIterable {
        case miss = "1-19", bad = "20-39", good = "40-65", great = "66-99", perfect = "100"
    }

    private lazy var popUpView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.anchor(height: 400)
        return view
    }()

    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = UIColor(named: "Black")
        button.addTarget(self, action: #selector(didTapDismisButton(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.text = "calendar explanation".localized
        label.textAlignment = .center
        return label
    }()

    private lazy var stackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }

    private func configureViews() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        view.addSubview(popUpView)
        popUpView.anchor(centerX: view.centerXAnchor,
                         horizontal: view,
                         paddingHorizontal: 30,
                         centerY: view.centerYAnchor)

        popUpView.addSubview(dismissButton)
        dismissButton.anchor(trailing: popUpView.trailingAnchor,
                             paddingTrailing: 10,
                             top: popUpView.topAnchor,
                             paddingTop: 10)

        popUpView.addSubview(descriptionLabel)
        descriptionLabel.anchor(centerX: view.centerXAnchor,
                                top: dismissButton.bottomAnchor,
                                paddingTop: 5)

        popUpView.addSubview(stackView)
        stackView.anchor(centerX: view.centerXAnchor,
                         top: descriptionLabel.bottomAnchor,
                         paddingTop: 20,
                         width: 120)

        for sticker in StickerPercent.allCases {
            let view = UIView()

            let imageView = UIImageView()
            imageView.image = UIImage(named: sticker.rawValue)

            let title = UILabel()
            title.text = sticker.rawValue + "%"

            view.anchor(width: 120,
                        height: 40)
            view.addSubview(imageView)
            imageView.anchor(leading: view.leadingAnchor,
                             top: view.topAnchor)
            view.addSubview(title)
            title.anchor(leading: imageView.trailingAnchor,
                         paddingLeading: 10,
                         centerY: imageView.centerYAnchor)

            stackView.addArrangedSubview(view)
        }
    }

    @objc private func didTapDismisButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
