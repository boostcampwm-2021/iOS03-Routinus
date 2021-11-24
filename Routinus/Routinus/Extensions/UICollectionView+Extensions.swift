//
//  UICollectionView+Extensions.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/24.
//

import UIKit

extension UICollectionView {
    func setEmptyView() {
        let emptyView: UIView = {
            let view = UIView(frame: CGRect(x: self.center.x,
                                            y: self.center.y,
                                            width: self.bounds.width,
                                            height: self.bounds.height))
            return view
        }()

        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "인증 목록이 비었습니다. 😞"
            label.textColor = .black
            label.font = UIFont.boldSystemFont(ofSize: 18)
            return label
        }()

        let messageLabel: UILabel = {
            let label = UILabel()
            label.text = "지금 바로 인증에 참여해주세요!"
            label.textColor = .lightGray
            label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            label.numberOfLines = 0
            label.textAlignment = .center
            return label
        }()

        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)

        titleLabel.anchor(centerX: emptyView.centerXAnchor,
                          centerY: emptyView.centerYAnchor)

        messageLabel.anchor(centerX: emptyView.centerXAnchor,
                            top: titleLabel.bottomAnchor, paddingTop: 20)

        self.backgroundView = emptyView
    }

    func restore() {
        self.backgroundView = nil
    }
}
