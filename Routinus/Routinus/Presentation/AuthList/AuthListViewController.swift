//
//  AuthListViewController.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/24.
//

import UIKit

class AuthListViewController: UIViewController {

    private var viewModel: AuthListViewModelIO?

    init(viewModel: AuthListViewModelIO) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
