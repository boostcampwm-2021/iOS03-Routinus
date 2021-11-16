//
//  SearchChallengeCell.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/09.
//

import UIKit

import SnapKit
import RoutinusDatabase

final class SearchChallengeCell: UICollectionViewCell {
    static let identifier = "SearchChallengeCell"

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }

    func setTitle(_ title: String) {
        titleLabel.text = title
    }

    func setImage(_ image: UIImage) {
        imageView.image = image
    }
}

extension SearchChallengeCell {
    private func configureViews() {
        self.addSubview(imageView)
        self.imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(110)
        }

        self.addSubview(titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(10)
        }
    }
}
