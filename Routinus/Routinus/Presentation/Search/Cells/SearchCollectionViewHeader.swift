//
//  SearchCollectionViewHeader.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/09.
//

import UIKit

final class SearchCollectionViewHeader: UICollectionReusableView {
    static let identifier = "SearchCollectionViewHeader"

    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "SystemForeground")
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    func updateTitle(_ title: String) {
        label.text = title
    }
}

extension SearchCollectionViewHeader {
    private func configure() {
        configureViews()
    }

    private func configureViews() {
        addSubview(label)
        label.anchor(leading: label.superview?.leadingAnchor,
                     centerY: label.superview?.centerYAnchor)
    }
}
