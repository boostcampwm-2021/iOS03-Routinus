//
//  ChallengeMainCell.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/04.
//

import UIKit

final class ChallengeMainCell: UICollectionViewCell {
    static let identifier = "mainCell"

    private let thumbnailImage = UIImageView()

    func configureViews() {
        self.addSubview(thumbnailImage)
        
        self.thumbnailImage.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
    
    private func resizedHeight(image: CGSize, newWidth: CGFloat) -> CGFloat {
        let scale = newWidth / image.width
        let newHeight = image.height * scale
        return newHeight
    }
}
