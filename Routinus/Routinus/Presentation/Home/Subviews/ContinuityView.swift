//
//  ContinuityView.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/07.
//

import UIKit

final class ContinuityView: UIView {
    private lazy var seedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "seed")
        imageView.isHidden = true
        return imageView
    }()

    private lazy var initContinuityLabel: UILabel = {
        let label = UILabel()
        label.text = "루티너스와 함께 시작해봐요!"
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.textColor = UIColor(named: "Black")
        label.isHidden = true
        return label
    }()

    private lazy var continuityDayLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.boldSystemFont(ofSize: 48)
        label.isHidden = true
        return label
    }()

    private lazy var continuityLabel: UILabel = {
        let label = UILabel()
        label.text = "in a row".localized
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.isHidden = true
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
        let isZero = user.continuityDay == 0

        seedImageView.isHidden = isZero
        initContinuityLabel.isHidden = !isZero
        continuityDayLabel.isHidden = isZero
        continuityLabel.isHidden = isZero
        continuityDayLabel.text = "\(user.continuityDay)"
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
        seedImageView.anchor(leading: self.leadingAnchor, paddingLeading: 20,
                             centerY: self.centerYAnchor,
                             width: 60, height: 60)

        addSubview(initContinuityLabel)
        initContinuityLabel.anchor(centerX: self.centerXAnchor,
                                   centerY: self.centerYAnchor)

        addSubview(continuityDayLabel)
        continuityDayLabel.anchor(leading: seedImageView.trailingAnchor, paddingLeading: 10,
                                  centerY: continuityDayLabel.superview?.centerYAnchor)

        addSubview(continuityLabel)
        continuityLabel.anchor(leading: continuityDayLabel.trailingAnchor, paddingLeading: 5,
                               bottom: continuityDayLabel.bottomAnchor, paddingBottom: 8)
    }
}
