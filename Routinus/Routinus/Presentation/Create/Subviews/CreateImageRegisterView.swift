//
//  CreateImageRegisterView.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/09.
//

import UIKit

import SnapKit

final class CreateImageRegisterView: UIView {
    weak var delegate: CreateImagePickerDelegate?

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
    
    func setImage(_ image: UIImage) {
        imageView.image = image
    }
}

extension CreateImageRegisterView {
    private func configure() {
        configureSubviews()
        configureGesture()
    }

    private func configureSubviews() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.width.equalToSuperview()
            make.height.equalTo(24)
        }

        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(150)
        }
    }

    private func configureGesture() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTappedImageView(_:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(recognizer)
    }

    @objc private func didTappedImageView(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended else { return }
        delegate?.didTappedImageView()
    }
}
