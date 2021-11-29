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
        label.textColor = UIColor(named: "Black")
        label.font = UIFont.boldSystemFont(ofSize: 18)

        return label
    }()

    var title: String = "" {
        didSet {
            label.text = title
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureViews()
    }

    func configureViews() {
        addSubview(label)

        label.anchor(leading: label.superview?.leadingAnchor,
                     centerY: label.superview?.centerYAnchor)
    }
}
