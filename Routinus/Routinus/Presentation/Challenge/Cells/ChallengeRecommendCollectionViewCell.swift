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
        label.text = "0명 참가"
        return label
    }()

    func configureViews(recommendChallenge: Challenge) {
        let category = recommendChallenge.category
        let image = UIImage(named: category.symbol) != nil
                    ? UIImage(named: category.symbol)
                    : UIImage(systemName: category.symbol)
        self.imageView.image = image
        self.imageView.tintColor = UIColor(named: category.color)

        self.titleLabel.text = recommendChallenge.title
        self.subtitleLabel.text = recommendChallenge.introduction
        self.encounterLabel.text = "\(recommendChallenge.participantCount)명 참가"

        self.layer.borderWidth = 1
        self.layer.cornerRadius = 15
        self.layer.borderColor = UIColor(named: "Black")?.cgColor

        self.addSubview(imageView)
        imageView.anchor(trailing: imageView.superview?.trailingAnchor, paddingTrailing: 10,
                         vertical: imageView.superview,
                         width: self.frame.size.width / 2.2)

        self.addSubview(titleLabel)
        titleLabel.anchor(horizontal: titleLabel.superview, paddingHorizontal: 25,
                          top: titleLabel.superview?.topAnchor, paddingTop: 35)

        self.addSubview(subtitleLabel)
        subtitleLabel.anchor(horizontal: titleLabel,
                             top: titleLabel.bottomAnchor, paddingTop: 5)

        self.addSubview(encounterView)

        self.encounterView.addSubview(encounterIcon)
        encounterIcon.anchor(leading: encounterIcon.superview?.leadingAnchor, paddingLeading: 15,
                             centerY: encounterIcon.superview?.centerYAnchor,
                             width: 16, height: 16)

        self.encounterView.addSubview(encounterLabel)
        encounterLabel.anchor(leading: encounterIcon.trailingAnchor, paddingLeading: 5,
                              centerY: encounterLabel.superview?.centerYAnchor)

        encounterView.anchor(leading: titleLabel.leadingAnchor,
                             trailing: encounterLabel.trailingAnchor, paddingTrailing: -15,
                             bottom: encounterView.superview?.bottomAnchor, paddingBottom: 20)

        let constraint = encounterView.heightAnchor.constraint(equalToConstant: 30)
        constraint.priority = UILayoutPriority(900)
        constraint.isActive = true
    }
}
