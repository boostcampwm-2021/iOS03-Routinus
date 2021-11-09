//
//  CreateDescView.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/09.
//

import UIKit

final class CreateDescView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
}

extension CreateDescView {
    private func configure() {
        
    }
}
