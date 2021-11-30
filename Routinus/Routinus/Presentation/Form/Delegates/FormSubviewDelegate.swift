//
//  FormSubviewDelegate.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/10.
//

import Foundation

protocol FormSubviewDelegate: AnyObject {
    func didChange(category: Challenge.Category)
    func didChange(imageURL: String)
    func didChange(authExampleImageURL: String)
    func didTappedCategoryButton()
}
