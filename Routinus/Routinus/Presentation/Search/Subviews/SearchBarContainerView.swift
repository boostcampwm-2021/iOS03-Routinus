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
            searchBar.delegate = delegate
        }
    }

    init() {
        super.init(frame: CGRect.zero)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        searchBar.frame = bounds
    }

    func hideKeyboard() {
        searchBar.endEditing(true)
    }

    func updateSearchBar(keyword: String) {
        searchBar.text = keyword
    }
}

extension SearchBarContainerView {
    private func configure() {
        self.addSubview(searchBar)
    }
}
