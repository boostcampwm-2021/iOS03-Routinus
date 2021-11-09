//
//  CreateViewController.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/02.
//

import Combine
import UIKit

import SnapKit

final class CreateViewController: UIViewController {
    // TODO: 임시 생성자 (CreateViewModel 작업 후 삭제)
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    // TODO: CreateViewModel 작업 후 주석 해제
//    init(with viewModel: CreateViewModelIO) {
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        configureViewModel()
    }
}

extension CreateViewController {
    private func configureViews() {
        view.backgroundColor = .white
    }
    
    private func configureViewModel() {
        // TODO: ViewModel 작업 후 Bind
    }
}
