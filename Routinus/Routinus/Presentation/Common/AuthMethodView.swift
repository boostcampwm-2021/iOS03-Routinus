//
//  AuthMethodView.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/16.
//

import UIKit

final class AuthMethodView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "인증 방법"
        label.font = UIFont.boldSystemFont(ofSize: 26)
        return label
    }()

    private lazy var methodImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .brown
        return imageView
    }()

    private lazy var introductionButton: UIButton = {
        let button = UIButton()
        button.setTitle("introduction", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets.left = 10
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 15
        button.isUserInteractionEnabled = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    func configureContents(challenge: Challenge) {
        self.introductionButton.setTitle(challenge.introduction, for: .normal)
    }
}

extension AuthMethodView {
    private func configure() {
        configureSubviews()
    }

    private func configureSubviews() {
        self.addSubview(titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true

        self.addSubview(methodImageView)
        self.methodImageView.translatesAutoresizingMaskIntoConstraints = false
        self.methodImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        self.methodImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.methodImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        self.methodImageView.heightAnchor.constraint(equalTo: self.methodImageView.widthAnchor, multiplier: 1).isActive = true

        self.addSubview(introductionButton)
        self.introductionButton.translatesAutoresizingMaskIntoConstraints = false
        self.introductionButton.topAnchor.constraint(equalTo: self.methodImageView.bottomAnchor, constant: 15).isActive = true
        self.introductionButton.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.introductionButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.introductionButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}
