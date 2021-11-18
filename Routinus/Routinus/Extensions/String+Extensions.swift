//
//  String+Extensions.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/16.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, value: self, comment: "")
    }
    
    func localized(with argument: CVarArg = []) -> String {
        return String(format: self.localized, argument)
    }
}
