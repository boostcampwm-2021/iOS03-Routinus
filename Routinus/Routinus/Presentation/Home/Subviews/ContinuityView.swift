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
        label.text = "시작이 반이다"
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
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
        continuityDayLabel.text = !isZero ? "\(user.continuityDay)" : continuityDayLabel.text
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
    }

    private func configureSubviews() {
        addSubview(seedImageView)
        seedImageView.anchor(left: seedImageView.superview?.leftAnchor, paddingLeft: 20,
                             centerY: seedImageView.superview?.centerYAnchor,
                             width: 60, height: 60)

        addSubview(initContinuityLabel)
        initContinuityLabel.anchor(left: seedImageView.rightAnchor, paddingLeft: 20,
                                   centerY: initContinuityLabel.superview?.centerYAnchor)

        addSubview(continuityDayLabel)
        continuityDayLabel.anchor(left: seedImageView.rightAnchor, paddingLeft: 10,
                                  centerY: continuityDayLabel.superview?.centerYAnchor)

        addSubview(continuityLabel)
        continuityLabel.anchor(left: continuityDayLabel.rightAnchor, paddingLeft: 5,
                               bottom: continuityDayLabel.bottomAnchor, paddingBottom: 8)
    }
}
