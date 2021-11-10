//
//  CategoryButtonTapGesture.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/09.
//

import UIKit

class CategoryButtonTapGesture: UITapGestureRecognizer {
    private (set) var category: Challenge.Category?
    
    func configureCategory(category: Challenge.Category) {
        self.category = category
    }
}

