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
    enum InputTag: Int {
        case category = 0, title, image, week, introduction, authMethod, authImage
    }
    
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
        button.isEnabled = false
        button.alpha = 0.5
        button.addTarget(self, action: #selector(didTappedCreateButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private var viewModel: CreateViewModelIO?
    private var cancellables = Set<AnyCancellable>()
    private var imagePicker = UIImagePickerController()
    private var selectedImagePickerTag: InputTag?

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
        configureGesture()
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
            make.height.equalTo(190)
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
                self.createButton.alpha = isEnabled ? 1 : 0.5
            })
            .store(in: &cancellables)

        self.viewModel?.expectedEndDate
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] endDate in
                guard let self = self else { return }
                self.weekView.updateEndDate(date: endDate)
            })
            .store(in: &cancellables)
    }

    private func configureDelegates() {
        imagePicker.delegate = self
        categoryView.delegate = self
        titleView.delegate = self
        imageRegisterView.delegate = self
        weekView.delegate = self
        introductionView.delegate = self
        authMethodView.delegate = self
        authImageRegisterView.delegate = self
    }
    
    private func configureGesture() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTappedScrollView(_:)))
        scrollView.addGestureRecognizer(recognizer)
    }
    
    @objc private func didTappedScrollView(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended else { return }
        titleView.hideKeyboard()
        weekView.hideKeyboard()
        introductionView.hideKeyboard()
        authMethodView.hideKeyboard()
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

extension CreateViewController: CreateImagePickerDelegate {
    func didTappedImageView(_ tag: Int) {
        var title = ""

        switch tag {
        case InputTag.image.rawValue:
            title = "챌린지 대표 이미지 등록"
            selectedImagePickerTag = .image
        case InputTag.authImage.rawValue:
            title = "인증샷 예시 이미지 등록"
            selectedImagePickerTag = .authImage
        default:
            return
        }
        
        let alert = UIAlertController(title: title,
                                      message: "사진 앱이나 카메라 앱을 선택할 수 있습니다.",
                                      preferredStyle: .actionSheet)

        let photo = UIAlertAction(title: "사진", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        alert.addAction(photo)

        let camera = UIAlertAction(title: "카메라", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        alert.addAction(camera)

        let cancel = UIAlertAction(title: "취소", style: .destructive, handler: nil)
        alert.addAction(cancel)

        present(alert, animated: true, completion: nil)
    }
}

extension CreateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    typealias InfoKey = UIImagePickerController.InfoKey
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [InfoKey: Any]) {
        if let image = info[InfoKey.originalImage] as? UIImage {
            guard let url = info[InfoKey.imageURL] as? URL else {
                dismiss(animated: true, completion: nil)
                return
            }
            let urlString = url.absoluteString
            
            switch selectedImagePickerTag {
            case .image:
                imageRegisterView.setImage(image)
                viewModel?.update(imageURL: urlString)
            case .authImage:
                authImageRegisterView.setImage(image)
                viewModel?.update(authExampleImageURL: urlString)
            default:
                ()
            }
        }
        dismiss(animated: true, completion: nil)
    }
}
