//
//  SearchPopularKeywordCell.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/09.
//

import UIKit

import SnapKit

class SearchPopularKeywordCell: UICollectionViewCell {
    static let identifier = "SearchPopularKeywordCell"
    weak var delegate: SearchPopularKeywordDelegate?

    private lazy var popularKeywordButton: SearchPopularKeywordButton = {
        let button = SearchPopularKeywordButton()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor(named: "SundayColor")
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: "SundayColor")?.cgColor
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(didTappedSearchKeyword), for: .touchUpInside)
        return button
    }()

    func configureViews(keyword: String) {
        self.popularKeywordButton.keyword = keyword
        self.popularKeywordButton.setTitle(keyword, for: .normal)
        self.addSubview(popularKeywordButton)
        self.popularKeywordButton.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
    }
    
    @objc func didTappedSearchKeyword(_ sender: SearchPopularKeywordButton) {
        delegate?.didTappedSearchKeywordButton(keyword: sender.keyword)
    }
}

protocol SearchPopularKeywordDelegate: AnyObject {
    func didTappedSearchKeywordButton(keyword: String?)
}
