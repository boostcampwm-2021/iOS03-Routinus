//
//  CreateImageRegisterView.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/09.
//

import UIKit

import SnapKit

final class CreateImageRegisterView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "챌린지 대표 이미지를 등록하세요."
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "camera")
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray
        imageView.tintColor = .black
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.systemGray.cgColor
        imageView.layer.cornerRadius = 10
        return imageView
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
}

extension CreateImageRegisterView {
    private func configure() {
        configureSubviews()
    }

    private func configureSubviews() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }

        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(150)
        }
    }
}
