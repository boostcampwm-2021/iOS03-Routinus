//
//  SearchCollectionViewHeader.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/09.
//

import UIKit

class SearchCollectionViewHeader: UICollectionReusableView {
    static let identifier = "SearchCollectionViewHeader"

    let label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        
        return label
    }()
    
    var title: String = "" {
        didSet {
            self.label.text = title
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureViews()
    }

    func configureViews() {
        self.addSubview(label)
    }
}