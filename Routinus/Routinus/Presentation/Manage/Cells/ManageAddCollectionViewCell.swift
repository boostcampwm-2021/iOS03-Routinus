//
//  ManageAddCollectionViewCell.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/21.
//

import UIKit

final class ManageAddCollectionViewCell: UICollectionViewCell {
    static let identifier = "ManageAddCollectionViewCell"

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "my challenges".localized
        label.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width <= 350 ? 30 : 34,
                                       weight: .bold)
        return label
    }()

    private lazy var addChallengeView = ChallengePromotionView()

    weak var delegate: ChallengePromotionViewDelegate? {
        didSet {
            addChallengeView.delegate = delegate
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension ManageAddCollectionViewCell {
    private func configureView() {
        let smallWidth = UIScreen.main.bounds.width <= 350
        let offset = smallWidth ? 28.0 : 32.0

        anchor(height: 250 + offset)

        addSubview(titleLabel)
        titleLabel.anchor(horizontal: self,
                          top: topAnchor, paddingTop: offset,
                          height: 80)

        addSubview(addChallengeView)
        addChallengeView.anchor(horizontal: self,
                                top: titleLabel.bottomAnchor, paddingTop: 10)
    }
}
