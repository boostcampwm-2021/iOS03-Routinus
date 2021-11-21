//
//  ManageAddCollectionViewCell.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/21.
//

import UIKit

final class ManageAddCollectionViewCell: UICollectionViewCell {
    static let identifier = "ManageAddCollectionViewCell"

    private lazy var addView = AddChallengeView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(addView)
        addView.anchor(edges: self)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
