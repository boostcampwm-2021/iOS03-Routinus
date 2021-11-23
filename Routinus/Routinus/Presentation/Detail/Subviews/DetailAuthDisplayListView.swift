//
//  DetailAuthDisplayListView.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/23.
//

import UIKit

final class DetailAuthDisplayListView: UIView {

    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "인증 목록"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()

    private lazy var allAuthDisplayView = DetailAuthDisplayView()
    private lazy var meAuthDisplayView = DetailAuthDisplayView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureSubviews()
    }

    convenience init() {
        self.init(frame: CGRect.zero)
    }
}

extension DetailAuthDisplayListView {
    private func configureSubviews() {
        self.backgroundColor = .systemBackground
        allAuthDisplayView.update(to: .all)
        meAuthDisplayView.update(to: .me)

        self.addSubview(titleLabel)
        titleLabel.anchor(leading: self.leadingAnchor, paddingLeading: 20,
                          top: self.topAnchor, paddingTop: 20)

        self.addSubview(allAuthDisplayView)
        allAuthDisplayView.anchor(leading: self.leadingAnchor, paddingLeading: 20,
                    trailing: self.trailingAnchor, paddingTrailing: 20,
                    top: titleLabel.bottomAnchor, paddingTop: 20)

        self.addSubview(meAuthDisplayView)
        meAuthDisplayView.anchor(leading: self.leadingAnchor, paddingLeading: 20,
                                  trailing: self.trailingAnchor, paddingTrailing: 20,
                                  top: allAuthDisplayView.bottomAnchor, paddingTop: 20,
                                  bottom: self.bottomAnchor, paddingBottom: 20)
    }
}
