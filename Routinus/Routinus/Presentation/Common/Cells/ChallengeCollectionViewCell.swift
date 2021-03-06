//
//  ChallengeCollectionViewCell.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/09.
//

import UIKit

final class ChallengeCollectionViewCell: UICollectionViewCell {
    static let identifier = "ChallengeCollectionViewCell"

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "SystemForeground")
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.lineBreakMode = .byTruncatingTail
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

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        imageView.image = nil
    }

    func updateTitle(_ title: String) {
        titleLabel.text = title
    }

    func updateImage(_ image: UIImage) {
        imageView.image = image
    }
}

extension ChallengeCollectionViewCell {
    private func configure() {
        configureViews()
    }

    private func configureViews() {
        addSubview(imageView)
        imageView.anchor(horizontal: imageView.superview,
                         top: imageView.superview?.topAnchor,
                         height: 110)

        addSubview(titleLabel)
        titleLabel.anchor(horizontal: titleLabel.superview,
                          top: imageView.bottomAnchor,
                          paddingTop: 10,
                          bottom: titleLabel.superview?.bottomAnchor)
    }
}
