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
    private lazy var introductionView = CreateIntroductionView()
    private lazy var authMethodView = CreateAuthMethodView()
    private lazy var authImageRegisterView = CreateAuthImageRegisterView()
    private lazy var createButton: UIButton = {
        var button = UIButton()
        button.setTitle("생성하기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.backgroundColor = UIColor(red: 180/255, green: 231/255, blue: 160/255, alpha: 1)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(didTappedCreateButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private var viewModel: CreateViewModelIO?
    private var cancellables = Set<AnyCancellable>()

    // TODO: 임시 생성자 (챌린지 관리화면 작업 후 삭제)
    init() {
        let repository = RoutinusRepository()
        let usecase = ChallengeCreateUsecase(repository: repository)
        viewModel = CreateViewModel(createUsecase: usecase)
        super.init(nibName: nil, bundle: nil)
    }

    // TODO: 챌린지 관리화면 작업 후 삭제
    init(with viewModel: CreateViewModelIO) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        configureViewModel()
        configureDelegates()
    }
    
    @objc private func didTappedCreateButton(_ sender: UIButton) {
        viewModel?.didTappedCreateButton()
        self.navigationController?.popViewController(animated: true)
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
            make.height.equalTo(100)
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
            make.height.equalTo(200)
        }

        stackView.addArrangedSubview(introductionView)
        introductionView.snp.makeConstraints { make in
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
        self.viewModel?.createButtonState
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] isEnabled in
                guard let self = self else { return }
                self.createButton.isEnabled = isEnabled
            })
            .store(in: &cancellables)
    }
    
    private func configureDelegates() {
        categoryView.delegate = self
        titleView.delegate = self
        weekView.delegate = self
        introductionView.delegate = self
        authMethodView.delegate = self
    }
}

extension CreateViewController: CreateSubviewDelegate {
    func didChange(category: Challenge.Category) {
        viewModel?.update(category: category)
    }
    
    func didChange(imageURL: String) {
        viewModel?.update(imageURL: imageURL)
    }
    
    func didChange(authExampleImageURL: String) {
        viewModel?.update(authExampleImageURL: authExampleImageURL)
    }
}

extension CreateViewController: UITextFieldDelegate, UITextViewDelegate {
    enum InputTag: Int {
        case title = 0, week, introduction, authMethod
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField.tag {
        case InputTag.title.rawValue:
            viewModel?.update(title: textField.text ?? "")
        case InputTag.week.rawValue:
            viewModel?.update(week: Int(textField.text ?? "") ?? 0)
        default:
            return
        }
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        switch textView.tag {
        case InputTag.introduction.rawValue:
            viewModel?.update(introduction: textView.text ?? "")
        case InputTag.authMethod.rawValue:
            viewModel?.update(authMethod: textView.text ?? "")
        default:
            return
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let viewModel = viewModel, let currentText = textField.text else { return true }
        switch textField.tag {
        case InputTag.title.rawValue:
            return viewModel.validateTextField(currentText: currentText, range: range, text: string)
        case InputTag.week.rawValue:
            return viewModel.validateTextField(currentText: currentText, range: range, text: string)
        default:
            return true
        }
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let viewModel = viewModel, let currentText = textView.text else { return true }
        switch textView.tag {
        case InputTag.introduction.rawValue:
            return viewModel.validateTextView(currentText: currentText, range: range, text: text)
        case InputTag.authMethod.rawValue:
            return viewModel.validateTextView(currentText: currentText, range: range, text: text)
        default:
            return true
        }
    }
}
