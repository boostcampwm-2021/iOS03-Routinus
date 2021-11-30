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
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    func update(to state: AuthDisplayState) {
        emojiLabel.text = state.emoji
        titleLabel.text = state.title
        descriptionLabel.text = state.description
    }
}

extension DetailAuthDisplayView {
    private func configure() {
        configureSubviews()
    }

    private func configureSubviews() {
        backgroundColor = .systemBackground
        layer.borderWidth = 1
        layer.borderColor = UIColor(named: "LightGray")?.cgColor
        layer.cornerRadius = 5

        addSubview(accessoryImageView)
        accessoryImageView.anchor(trailing: trailingAnchor,
                                  paddingTrailing: 20,
                                  centerY: centerYAnchor)

        addSubview(emojiLabel)
        emojiLabel.anchor(leading: leadingAnchor,
                          paddingLeading: 20,
                          top: topAnchor,
                          paddingTop: 20,
                          height: 20)

        addSubview(titleLabel)
        titleLabel.anchor(leading: emojiLabel.trailingAnchor,
                          paddingLeading: 10,
                          top: topAnchor, paddingTop: 20,
                          height: 20)

        addSubview(descriptionLabel)
        descriptionLabel.anchor(leading: leadingAnchor,
                                paddingLeading: 20,
                                trailing: accessoryImageView.leadingAnchor,
                                paddingTrailing: 5,
                                top: emojiLabel.bottomAnchor,
                                paddingTop: 20,
                                bottom: bottomAnchor,
                                paddingBottom: 20)
    }
}
