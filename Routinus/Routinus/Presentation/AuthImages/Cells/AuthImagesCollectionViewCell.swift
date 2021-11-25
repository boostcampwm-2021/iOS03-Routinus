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
        imageView.clipsToBounds = true
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureCell()
    }

    func update(image: UIImage) {
        imageView.image = image
    }
}

extension AuthImagesCollectionViewCell {
    private func configureCell() {
        self.addSubview(imageView)
        imageView.anchor(leading: self.leadingAnchor,
                         trailing: self.trailingAnchor,
                         top: self.topAnchor,
                         bottom: self.bottomAnchor)
    }
}
