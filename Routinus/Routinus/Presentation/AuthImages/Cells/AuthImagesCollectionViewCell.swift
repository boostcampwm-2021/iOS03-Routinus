//
//  AuthImagesCollectionViewCell.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/24.
//

import UIKit

final class AuthImagesCollectionViewCell: UICollectionViewCell {
    static let identifier = "AuthImagesCollectionViewCell"

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
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

    func update(image: UIImage) {
        imageView.image = image
    }

    func imageData() -> Data {
        guard let imageData = imageView.image?.jpegData(compressionQuality: 1) else { return Data() }
        return imageData
    }
}

extension AuthImagesCollectionViewCell {
    private func configure() {
        configureCell()
    }

    private func configureCell() {
        addSubview(imageView)
        imageView.anchor(leading: leadingAnchor,
                         trailing: trailingAnchor,
                         top: topAnchor,
                         bottom: bottomAnchor)
    }
}
