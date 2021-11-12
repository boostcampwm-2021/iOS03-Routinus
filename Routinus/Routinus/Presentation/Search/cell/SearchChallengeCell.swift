//
//  SearchChallengeCell.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/09.
//

import UIKit

import SnapKit
import Kingfisher
import RoutinusDatabase

final class SearchChallengeCell: UICollectionViewCell {
    static let identifier = "SearchChallengeCell"

    private lazy var challengeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.tintColor = UIColor(named: "MainColor")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    func configureViews(challenge: Challenge) {
        self.titleLabel.text = challenge.title

        self.addSubview(challengeImageView)
        self.challengeImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(110)
        }

        self.addSubview(titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview()
            make.top.equalTo(challengeImageView.snp.bottom).offset(10)
        }

        // TODO: RoutinusDatabase 직접 접근하지 않도록 수정
        Task {
            let url = try? await RoutinusDatabase.imageURL(id: challenge.challengeID, fileName: "image")

            self.challengeImageView.kf.setImage(with: url,
                                                placeholder: UIImage(systemName: "photo"))
        }
    }
}
