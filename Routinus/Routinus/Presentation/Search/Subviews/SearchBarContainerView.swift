//
//  SearchBarContainerView.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/11.
//

import UIKit

final class SearchBarContainerView: UIView {
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()

    weak var delegate: UISearchBarDelegate? {
        didSet {
            self.searchBar.delegate = delegate
        }
    }

    init() {
        super.init(frame: CGRect.zero)
        addSubview(searchBar)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.searchBar.frame = bounds
    }

    func hideKeyboard() {
        self.searchBar.endEditing(true)
    }

    func configureKeyword(keyword: String) {
        self.searchBar.text = keyword
    }
}
