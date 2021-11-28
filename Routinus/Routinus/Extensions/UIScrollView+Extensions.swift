//
//  UIScrollView+Extensions.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/27.
//

import UIKit

extension UIScrollView {
    func removeAfterimage() {
        self.refreshControl?.beginRefreshing()
        self.refreshControl?.endRefreshing()
    }
}
