//
//  ChallengeRecommendCell.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/04.
//

import UIKit

final class ChallengeRecommendCell: UICollectionViewCell {
    static let identifier = "recommendCell"

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines = 2
        return label
    }()

    private lazy var encounterView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "MainColor")
        view.layer.cornerRadius = 15
        return view
    }()

    private lazy var encounterIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "person")
        image.tintColor = .black
        return image
    }()

    private lazy var encounterLabel: UILabel = {
        let label = UILabel()
        label.text = "0명 참가"
        return label
    }()

    func configureViews(recommendChallenge: Challenge) {

        self.titleLabel.text = recommendChallenge.title
        self.subtitleLabel.text = recommendChallenge.introduction
        self.encounterLabel.text = "\(recommendChallenge.participantCount)명 참가"

        self.layer.borderWidth = 1
        self.layer.cornerRadius = 15

        self.addSubview(titleLabel)
        titleLabel.anchor(horizontal: titleLabel.superview, paddingHorizontal: 25,
                          top: titleLabel.superview?.topAnchor, paddingTop: 35)

        self.addSubview(subtitleLabel)
        subtitleLabel.anchor(horizontal: titleLabel,
                             top: titleLabel.bottomAnchor, paddingTop: 5)

        self.addSubview(encounterView)

        self.encounterView.addSubview(encounterIcon)
        encounterIcon.anchor(left: encounterIcon.superview?.leftAnchor, paddingLeft: 15,
                             centerY: encounterIcon.superview?.centerYAnchor,
                             width: 16, height: 16)

        self.encounterView.addSubview(encounterLabel)
        encounterLabel.anchor(left: encounterIcon.rightAnchor, paddingLeft: 5,
                              centerY: encounterLabel.superview?.centerYAnchor)

        encounterView.anchor(left: titleLabel.leftAnchor,
                             right: encounterLabel.rightAnchor, paddingRight: -15,
                             bottom: encounterView.superview?.bottomAnchor, paddingBottom: 20,
                             height: encounterIcon.frame.height + 25)
    }
}
