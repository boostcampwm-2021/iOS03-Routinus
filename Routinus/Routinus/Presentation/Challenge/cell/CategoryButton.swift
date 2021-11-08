//
//  CategoryButton.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/08.
//

import UIKit

class CategoryButton: UIButton {
    var categoty: Category?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
