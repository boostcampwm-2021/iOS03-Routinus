//
//  ChallengeRecommendCell.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/04.
//

import UIKit

final class ChallengeRecommendCell: UICollectionViewCell {
    static let identifier = "eventsCell"

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 2
        return label
    }()

    func configureViews(data: String) {

        self.titleLabel.text = data
        self.subtitleLabel.text = "subtitle"

        self.layer.borderWidth = 1
        self.layer.cornerRadius = 15

        self.addSubview(titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(5)
            make.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(20)
        }

        self.addSubview(subtitleLabel)
        self.subtitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalToSuperview().offset(5)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(5
            )
        }
    }
}
