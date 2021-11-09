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
    private lazy var scrollView: UIScrollView = UIScrollView()
    private lazy var stackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var categoryView = CreateCategoryView()
    private lazy var titleView = CreateTitleView()
    private lazy var imageRegisterView = CreateImageRegisterView()
    private lazy var weekView = CreateWeekView()
    private lazy var descView = CreateDescView()
    private lazy var authMethodView = CreateAuthMethodView()
    private lazy var authImageRegisterView = CreateAuthImageRegisterView()
    private lazy var createButton: UIButton = {
        var button = UIButton()
        button.setTitle("생성하기", for: .normal)
        button.setTitleColor(.systemGreen, for: .normal)
        return button
    }()
    
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
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.width.centerX.top.bottom.equalToSuperview()
        }
        
        stackView.addArrangedSubview(categoryView)
        stackView.addArrangedSubview(titleView)
        stackView.addArrangedSubview(imageRegisterView)
        stackView.addArrangedSubview(weekView)
        stackView.addArrangedSubview(descView)
        stackView.addArrangedSubview(authMethodView)
        stackView.addArrangedSubview(authImageRegisterView)
        stackView.addArrangedSubview(createButton)
    }
    
    private func configureViewModel() {
        // TODO: ViewModel 작업 후 Bind
    }
}
