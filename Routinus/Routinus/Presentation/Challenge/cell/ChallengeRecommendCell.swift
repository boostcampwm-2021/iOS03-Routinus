//
//  ChallengeRecommendCell.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/04.
//

import UIKit
import SnapKit

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
        label.text = "27명 참가"
        return label
    }()

    func configureViews(data: String) {

        self.titleLabel.text = data
        self.subtitleLabel.text = "subtitle"

        self.layer.borderWidth = 1
        self.layer.cornerRadius = 15

        self.addSubview(titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(25)
            make.top.equalToSuperview().offset(35)
            make.trailing.equalToSuperview()
        }

        self.addSubview(subtitleLabel)
        self.subtitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(5)
            make.trailing.equalToSuperview().offset(5)
        }

        self.addSubview(encounterView)

        self.encounterView.addSubview(encounterIcon)
        self.encounterIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(16)
        }

        self.encounterView.addSubview(encounterLabel)
        self.encounterLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.encounterIcon.snp.trailing).offset(5)
            make.centerY.equalToSuperview()
        }

        self.encounterView.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(self.subtitleLabel.snp.bottom).offset(20)
            make.trailing.equalTo(self.encounterLabel.snp.trailing).offset(15)
            make.height.equalTo(encounterIcon.snp.height).offset(15)
        }
    }
}
