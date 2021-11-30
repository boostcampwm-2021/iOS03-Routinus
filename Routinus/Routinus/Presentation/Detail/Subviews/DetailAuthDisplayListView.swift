//
//  DetailAuthDisplayListView.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/23.
//

import UIKit

final class DetailAuthDisplayListView: UIView {
    weak var delegate: AuthDisplayViewDelegate?

    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "auth list".localized
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    private lazy var allAuthDisplayView: DetailAuthDisplayView = {
        var detailAuthDisplayView = DetailAuthDisplayView()

        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(didTappedAllAuthDisplayView))
        gesture.numberOfTapsRequired = 1
        detailAuthDisplayView.isUserInteractionEnabled = true
        detailAuthDisplayView.addGestureRecognizer(gesture)

        return detailAuthDisplayView
    }()
    private lazy var myAuthDisplayView: DetailAuthDisplayView = {
        var myAuthDisplayView = DetailAuthDisplayView()

        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(didTappedMyAuthDisplayView))
        gesture.numberOfTapsRequired = 1
        myAuthDisplayView.isUserInteractionEnabled = true
        myAuthDisplayView.addGestureRecognizer(gesture)

        return myAuthDisplayView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    convenience init() {
        self.init(frame: CGRect.zero)
    }
}

extension DetailAuthDisplayListView {
    private func configure() {
        configureSubviews()
    }

    private func configureSubviews() {
        backgroundColor = .systemBackground
        allAuthDisplayView.update(to: .all)
        myAuthDisplayView.update(to: .my)

        addSubview(titleLabel)
        titleLabel.anchor(leading: leadingAnchor, paddingLeading: 20,
                          top: topAnchor, paddingTop: 20)

        addSubview(allAuthDisplayView)
        allAuthDisplayView.anchor(leading: leadingAnchor, paddingLeading: 20,
                                  trailing: trailingAnchor, paddingTrailing: 20,
                                  top: titleLabel.bottomAnchor, paddingTop: 20)

        addSubview(myAuthDisplayView)
        myAuthDisplayView.anchor(leading: leadingAnchor, paddingLeading: 20,
                                 trailing: trailingAnchor, paddingTrailing: 20,
                                 top: allAuthDisplayView.bottomAnchor, paddingTop: 20,
                                 bottom: bottomAnchor, paddingBottom: 20)
    }

    @objc func didTappedAllAuthDisplayView() {
        delegate?.didTappedAllAuthDisplayView()
    }

    @objc func didTappedMyAuthDisplayView() {
        delegate?.didTappedMyAuthDisplayView()
    }
}

protocol AuthDisplayViewDelegate: AnyObject {
    func didTappedAllAuthDisplayView()
    func didTappedMyAuthDisplayView()
}
