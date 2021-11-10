//
//  CreateAuthImageRegisterView.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/09.
//

import UIKit

import SnapKit

final class CreateAuthImageRegisterView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "인증샷 예시를 등록하세요."
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "다른 사람들이 인증 방법을 이해하기 쉽도록 인증샷을 추가 해주세요."
        label.font = .systemFont(ofSize: 16)
        label.textColor = .systemGray
        label.numberOfLines = 2
        return label
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "camera")
        imageView.contentMode = .scaleAspectFit
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

extension CreateAuthImageRegisterView {
    private func configure() {
        configureSubviews()
    }

    private func configureSubviews() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.width.equalToSuperview()
            make.height.equalTo(24)
        }

        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.width.equalToSuperview()
        }

        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(150)
        }
    }
}
