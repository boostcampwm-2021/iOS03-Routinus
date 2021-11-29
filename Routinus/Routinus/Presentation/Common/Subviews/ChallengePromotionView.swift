//
//  AddChallengeView.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/20.
//

import UIKit

protocol ChallengePromotionViewDelegate: AnyObject {
    func didTappedPromotionButton()
}

final class ChallengePromotionView: UIView {
    weak var delegate: ChallengePromotionViewDelegate?

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "make your challenge".localized
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()

    private lazy var promotionButton: UIButton = {
        let button = UIButton()
        button.setTitle("make challenge".localized, for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.backgroundColor = UIColor(named: "MainColor")
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(didTappedPromotionButton), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }

    convenience init() {
        self.init(frame: CGRect.zero)
    }

    func configureChallengePromotionView(titleLabel: String, buttonLabel: String) {
        self.titleLabel.text = titleLabel
        self.promotionButton.setTitle(buttonLabel, for: .normal)
    }
}

extension ChallengePromotionView {
    private func configureView() {
        backgroundColor = UIColor(named: "MainColor")?.withAlphaComponent(0.5)
        layer.cornerRadius = 10
        anchor(height: 160)

        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(promotionButton)
        stackView.anchor(centerX: centerXAnchor, centerY: centerYAnchor)
    }

    @objc func didTappedPromotionButton() {
        delegate?.didTappedPromotionButton()
    }
}
