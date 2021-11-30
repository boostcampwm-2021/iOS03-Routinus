//
//  SearchPopularKeywordCollectionViewCell.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/09.
//

import UIKit

final class SearchPopularKeywordCollectionViewCell: UICollectionViewCell {
    static let identifier = "SearchPopularKeywordCollectionViewCell"

    weak var delegate: SearchPopularKeywordDelegate?

    private lazy var popularKeywordButton: PopularKeywordButton = {
        let button = PopularKeywordButton()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor(named: "SundayColor")
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: "SundayColor")?.cgColor
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(didTappedPopularKeyword), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    func updateKeyword(_ keyword: String) {
        popularKeywordButton.keyword = keyword
        popularKeywordButton.setTitle(keyword, for: .normal)
    }
}

extension SearchPopularKeywordCollectionViewCell {
    private func configure() {
        configureViews()
    }

    private func configureViews() {
        addSubview(popularKeywordButton)
        popularKeywordButton.anchor(horizontal: popularKeywordButton.superview,
                                    vertical: popularKeywordButton.superview)
    }

    @objc private func didTappedPopularKeyword(_ sender: PopularKeywordButton) {
        delegate?.didTappedKeywordButton(keyword: sender.keyword)
    }
}
