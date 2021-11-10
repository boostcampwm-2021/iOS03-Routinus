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

    private var popularTerm: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.tintColor = UIColor.white
        button.backgroundColor = UIColor(named: "SearchTermColor")
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: "SearchTermColor")?.cgColor
        button.layer.cornerRadius = 15
        return button
    }()

    func configureViews(searchTerm: String) {
        self.popularTerm.setTitle(searchTerm, for: .normal)
        self.addSubview(popularTerm)
        self.popularTerm.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
    }
}
