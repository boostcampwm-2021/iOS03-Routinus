//
//  DetailAuthDisplayView.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/23.
//

import UIKit

enum AuthDisplayState {
    case all
    case my

    var title: String {
        switch self {
        case .all:
            return "everyone auth title".localized
        case .my:
            return "my auth title".localized
        }
    }

    var description: String {
        switch self {
        case .all:
            return "everyone auth subtitle".localized
        case .my:
            return "my auth subtitle".localized
        }
    }

    var emoji: String {
        switch self {
        case .all:
            return "🤵🏻‍♀️🤵🏻"
        case .my:
            return "🤵🏻‍♀️"
        }
    }
}

final class DetailAuthDisplayView: UIView {
    private lazy var emojiLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()

    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()

    private lazy var accessoryImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = UIColor(named: "Black")
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        configureSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
        configureSubviews()
    }

    func update(to state: AuthDisplayState) {
        emojiLabel.text = state.emoji
        titleLabel.text = state.title
        descriptionLabel.text = state.description
    }
}

extension DetailAuthDisplayView {
    private func configure() {
        self.backgroundColor = .systemBackground
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(named: "LightGray")?.cgColor
        self.layer.cornerRadius = 5
    }

    private func configureSubviews() {
        self.addSubview(accessoryImageView)
        accessoryImageView.anchor(trailing: self.trailingAnchor, paddingTrailing: 20,
                                  centerY: self.centerYAnchor)

        self.addSubview(emojiLabel)
        emojiLabel.anchor(leading: self.leadingAnchor, paddingLeading: 20,
                          top: self.topAnchor, paddingTop: 20,
                          height: 20)

        self.addSubview(titleLabel)
        titleLabel.anchor(leading: emojiLabel.trailingAnchor, paddingLeading: 10,
                          top: self.topAnchor, paddingTop: 20, height: 20)

        self.addSubview(descriptionLabel)
        descriptionLabel.anchor(leading: self.leadingAnchor, paddingLeading: 20,
                                trailing: accessoryImageView.leadingAnchor, paddingTrailing: 5,
                                top: emojiLabel.bottomAnchor, paddingTop: 20,
                                bottom: self.bottomAnchor, paddingBottom: 20)
    }
}
