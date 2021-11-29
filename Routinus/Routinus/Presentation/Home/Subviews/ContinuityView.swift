//
//  ContinuityView.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/07.
//

import UIKit

enum ContinuityState: String {
    case bronze = "seed1"
    case silver = "seed2"
    case gold = "seed3"
    case platinum = "seed4"
    case diamond = "seed5"

    static func image(for value: Int) -> String {
        let state: ContinuityState
        switch value {
        case 0..<1:
            state = .bronze
        case 1..<2:
            state = .silver
        case 2..<3:
            state = .gold
        case 3..<4:
            state = .platinum
        case 4...:
            state = .diamond
        default:
            state = .bronze
        }
        return state.rawValue
    }
}

final class ContinuityView: UIView {
    private lazy var seedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var continuityDayLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.boldSystemFont(ofSize: 48)
        return label
    }()

    private lazy var continuityLabel: UILabel = {
        let label = UILabel()
        label.text = "in a row".localized
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        return label
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

    func configureContents(with user: User) {
        guard !user.name.isEmpty else { return }
        continuityDayLabel.text = "\(user.continuityDay)"
        seedImageView.image = UIImage(named: ContinuityState.image(for: user.continuityDay))
    }
}

extension ContinuityView {
    private func configure() {
        configureLayout()
        configureSubviews()
    }

    private func configureLayout() {
        layer.borderWidth = 1
        layer.cornerRadius = 5
        layer.borderColor = UIColor(named: "Black")?.cgColor
    }

    private func configureSubviews() {
        addSubview(seedImageView)
        seedImageView.anchor(leading: self.leadingAnchor,
                             paddingLeading: 20,
                             centerY: self.centerYAnchor,
                             width: 60,
                             height: 60)

        addSubview(continuityDayLabel)
        continuityDayLabel.anchor(leading: seedImageView.trailingAnchor,
                                  paddingLeading: 10,
                                  centerY: continuityDayLabel.superview?.centerYAnchor)

        addSubview(continuityLabel)
        continuityLabel.anchor(leading: continuityDayLabel.trailingAnchor,
                               paddingLeading: 5,
                               bottom: continuityDayLabel.bottomAnchor,
                               paddingBottom: 8)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            layer.borderColor = UIColor(named: "Black")?.cgColor
        }
    }
}
