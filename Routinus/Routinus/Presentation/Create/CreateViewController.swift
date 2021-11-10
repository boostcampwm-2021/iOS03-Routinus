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
        stackView.spacing = 30
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
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.backgroundColor = UIColor(red: 180/255, green: 231/255, blue: 160/255, alpha: 1)
        button.layer.cornerRadius = 20
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
            make.top.bottom.left.right.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }

        stackView.addArrangedSubview(categoryView)
        categoryView.snp.makeConstraints { make in
            make.height.equalTo(220)
        }

        stackView.addArrangedSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.height.equalTo(120)
        }

        stackView.addArrangedSubview(imageRegisterView)
        imageRegisterView.snp.makeConstraints { make in
            make.height.equalTo(220)
        }

        stackView.addArrangedSubview(weekView)
        weekView.snp.makeConstraints { make in
            make.height.equalTo(170)
        }

        stackView.addArrangedSubview(descView)
        descView.snp.makeConstraints { make in
            make.height.equalTo(240)
        }

        stackView.addArrangedSubview(authMethodView)
        authMethodView.snp.makeConstraints { make in
            make.height.equalTo(255)
        }

        stackView.addArrangedSubview(authImageRegisterView)
        authImageRegisterView.snp.makeConstraints { make in
            make.height.equalTo(260)
        }

        stackView.addArrangedSubview(createButton)
        createButton.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
    }

    private func configureViewModel() {
        // TODO: ViewModel 작업 후 Bind
    }
}
