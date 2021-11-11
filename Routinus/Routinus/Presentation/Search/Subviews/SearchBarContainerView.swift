//
//  SearchBarContainerView.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/11.
//

import UIKit

class SearchBarContainerView: UIView {
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        addSubview(searchBar)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        searchBar.frame = bounds
    }
}
