//
//  SearchChallengeCell.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/09.
//

import UIKit
import SnapKit

final class SearchChallengeCell: UICollectionViewCell {
    static let identifier = "SearchChallengeCell"

    private lazy var challengeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "folder")
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    func configureViews(challenge: Challenge) {

        self.titleLabel.text = challenge.title
//        self.challengeImageView.image = UIImage(data: challenge.imageData)

        self.addSubview(challengeImageView)
        self.challengeImageView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }

        self.addSubview(titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(self.challengeImageView.snp.bottom).offset(10)
        }
    }
}

struct Challenge: Hashable {
    let challengeID: String
    let title: String
    let imageData: Data?
}
