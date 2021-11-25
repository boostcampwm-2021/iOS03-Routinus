//
//  UICollectionView+Extensions.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/24.
//

import UIKit

extension UICollectionView {
    func notifyEmptyData() {
        let informationView: UIView = {
            let view = UIView(frame: CGRect(x: self.center.x,
                                            y: self.center.y,
                                            width: self.bounds.width,
                                            height: self.bounds.height))
            return view
        }()

        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "auth empty".localized
            label.textColor = .black
            label.font = UIFont.boldSystemFont(ofSize: 18)
            return label
        }()

        let messageLabel: UILabel = {
            let label = UILabel()
            label.text = "lets auth".localized
            label.textColor = .lightGray
            label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
            label.numberOfLines = 0
            label.textAlignment = .center
            label.numberOfLines = 2
            return label
        }()

        informationView.addSubview(titleLabel)
        informationView.addSubview(messageLabel)

        titleLabel.anchor(centerX: informationView.centerXAnchor,
                          centerY: informationView.centerYAnchor)

        messageLabel.anchor(centerX: informationView.centerXAnchor,
                            top: titleLabel.bottomAnchor, paddingTop: 20)

        self.backgroundView = informationView
    }

    func restore() {
        self.backgroundView = nil
    }
}
