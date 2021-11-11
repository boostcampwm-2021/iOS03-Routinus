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
        button.setTitle("", for: .normal)
        button.tintColor = UIColor.white
        button.backgroundColor = UIColor(named: "SearchKeywordColor")
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: "SearchKeywordColor")?.cgColor
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
