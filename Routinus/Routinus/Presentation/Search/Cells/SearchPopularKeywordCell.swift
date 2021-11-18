//
//  SearchPopularKeywordCell.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/09.
//

import UIKit

final class SearchPopularKeywordCell: UICollectionViewCell {
    static let identifier = "SearchPopularKeywordCell"
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

    func configureViews(keyword: String) {
        self.popularKeywordButton.keyword = keyword
        self.popularKeywordButton.setTitle(keyword, for: .normal)
        self.addSubview(popularKeywordButton)
        popularKeywordButton.anchor(horizontal: popularKeywordButton.superview,
                                    vertical: popularKeywordButton.superview)
    }

    @objc func didTappedPopularKeyword(_ sender: PopularKeywordButton) {
        delegate?.didTappedKeywordButton(keyword: sender.keyword)
    }
}

protocol SearchPopularKeywordDelegate: AnyObject {
    func didTappedKeywordButton(keyword: String?)
}
