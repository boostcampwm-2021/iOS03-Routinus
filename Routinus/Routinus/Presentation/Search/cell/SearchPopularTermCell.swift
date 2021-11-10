//
//  SearchPopularTermCell.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/09.
//

import UIKit

import SnapKit

class SearchPopularTermCell: UICollectionViewCell {
    static let identifier = "SearchPopularTermCell"
    weak var delegate: SearchPopularTermDelegate?

    private lazy var popularTerm: PopularTermButton = {
        let button = PopularTermButton()
        button.setTitle("", for: .normal)
        button.tintColor = UIColor.white
        button.backgroundColor = UIColor(named: "SearchTermColor")
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: "SearchTermColor")?.cgColor
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(didTappedSearchTerm), for: .touchUpInside)
        return button
    }()

    func configureViews(term: String) {
        self.popularTerm.term = term
        self.popularTerm.setTitle(term, for: .normal)
        self.addSubview(popularTerm)
        self.popularTerm.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
    }
    
    @objc func didTappedSearchTerm(_ sender: PopularTermButton) {
        delegate?.didTappedSearchTermButton(term: sender.term)
    }
}

protocol SearchPopularTermDelegate: AnyObject {
    func didTappedSearchTermButton(term: String?)
}
