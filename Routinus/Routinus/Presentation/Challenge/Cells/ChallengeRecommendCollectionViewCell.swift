//
//  ChallengeRecommendCollectionViewCell.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/04.
//

import UIKit

final class ChallengeRecommendCollectionViewCell: UICollectionViewCell {
    static let identifier = "ChallengeRecommendCollectionViewCell"

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0.3
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor =  UIColor(named: "Black")
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "DayColor")
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines = 2
        return label
    }()

    private lazy var encounterView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "MainColor")?.withAlphaComponent(0.7)
        view.layer.cornerRadius = 15
        return view
    }()

    private lazy var encounterIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "person")
        image.tintColor = UIColor(named: "Black")
        return image
    }()

    private lazy var encounterLabel: UILabel = {
        let label = UILabel()
        label.text = "%d people".localized
        return label
    }()

    func configureViews(recommendChallenge: Challenge) {
        let category = recommendChallenge.category
        let image = UIImage(named: category.symbol) != nil ? UIImage(named: category.symbol) : UIImage(systemName: category.symbol)
        imageView.image = image
        imageView.tintColor = UIColor(named: category.color)

        titleLabel.text = recommendChallenge.title
        subtitleLabel.text = recommendChallenge.introduction
        encounterLabel.text = "%d people".localized(with: recommendChallenge.participantCount)

        layer.borderWidth = 1
        layer.cornerRadius = 15
        layer.borderColor = UIColor(named: "Black")?.cgColor

        addSubview(imageView)
        imageView.anchor(trailing: imageView.superview?.trailingAnchor,
                         paddingTrailing: 10,
                         vertical: imageView.superview,
                         width: frame.size.width / 2.2)

        addSubview(titleLabel)
        titleLabel.anchor(horizontal: titleLabel.superview,
                          paddingHorizontal: 25,
                          top: titleLabel.superview?.topAnchor,
                          paddingTop: 35)

        addSubview(subtitleLabel)
        subtitleLabel.anchor(horizontal: titleLabel,
                             top: titleLabel.bottomAnchor,
                             paddingTop: 5)

        addSubview(encounterView)

        encounterView.addSubview(encounterIcon)
        encounterIcon.anchor(leading: encounterIcon.superview?.leadingAnchor,
                             paddingLeading: 15,
                             centerY: encounterIcon.superview?.centerYAnchor,
                             width: 16,
                             height: 16)

        encounterView.addSubview(encounterLabel)
        encounterLabel.anchor(leading: encounterIcon.trailingAnchor,
                              paddingLeading: 5,
                              centerY: encounterLabel.superview?.centerYAnchor)

        encounterView.anchor(leading: titleLabel.leadingAnchor,
                             trailing: encounterLabel.trailingAnchor,
                             paddingTrailing: -15,
                             bottom: encounterView.superview?.bottomAnchor,
                             paddingBottom: 20)

        let constraint = encounterView.heightAnchor.constraint(equalToConstant: 30)
        constraint.priority = UILayoutPriority(900)
        constraint.isActive = true
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            layer.borderColor = UIColor(named: "Black")?.cgColor
        }
    }
}
