//
//  SearchPopularKeywordButton.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/10.
//

import UIKit

final class PopularKeywordButton: UIButton {
    var keyword: String?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
