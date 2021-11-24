//
//  CreateViewController.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/02.
//

import Combine
import UIKit

final class CreateViewController: UIViewController {
    enum InputTag: Int {
        case category = 0, title, image, week, introduction, authMethod, authImage
    }

    private lazy var scrollView: UIScrollView = UIScrollView()
    private lazy var stackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 35
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
        button.setTitle(ButtonType.create.rawValue, for: .normal)
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
    private var constraint: NSLayoutConstraint?

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
        configureNotifications()
    }

    @objc private func didTappedCreateButton(_ sender: UIButton) {
        viewModel?.didTappedCreateButton()
        presentAlert()
    }
}

extension CreateViewController {
    private func configureViews() {
        view.backgroundColor = .systemBackground

        view.addSubview(scrollView)
        scrollView.anchor(edges: view.safeAreaLayoutGuide)

        scrollView.addSubview(stackView)

        stackView.anchor(centerX: stackView.superview?.centerXAnchor,
                         horizontal: stackView.superview, paddingHorizontal: 20,
                         top: stackView.superview?.topAnchor, paddingTop: 20)
        constraint = stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor,
                                                       constant: 0)
        constraint?.isActive = true

        stackView.addArrangedSubview(categoryView)
        stackView.addArrangedSubview(titleView)
        stackView.addArrangedSubview(imageRegisterView)
        stackView.addArrangedSubview(weekView)
        stackView.addArrangedSubview(introductionView)
        stackView.addArrangedSubview(authMethodView)
        stackView.addArrangedSubview(authImageRegisterView)
        stackView.addArrangedSubview(createButton)
        createButton.anchor(height: 55)
    }

    private func configureViewModel() {
        self.viewModel?.didLoadedChallenge()

        self.viewModel?.buttonType
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] buttonType in
                guard let self = self else { return }
                self.createButton.setTitle(buttonType.rawValue, for: .normal)
            })
            .store(in: &cancellables)

        self.viewModel?.buttonState
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

        self.viewModel?.challenge
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] challenge in
                guard let self = self, let challenge = challenge else { return }

                self.categoryView.update(category: challenge.category)
                self.titleView.update(title: challenge.title)
                self.viewModel?.imageData(from: challenge.challengeID,
                                          filename: "thumbnail_image",
                                          completion: { data in
                    guard let data = data, let image = UIImage(data: data) else { return }
                    DispatchQueue.main.async {
                        self.imageRegisterView.setImage(image)
                    }
                })
                self.weekView.update(week: challenge.week) 
                self.introductionView.update(introduction: challenge.introduction)
                self.authMethodView.update(authMethod: challenge.authMethod)
                self.viewModel?.imageData(from: challenge.challengeID,
                                          filename: "thumbnail_auth_method",
                                          completion: { data in
                    guard let data = data, let image = UIImage(data: data) else { return }
                    DispatchQueue.main.async {
                        self.authImageRegisterView.setImage(image)
                    }
                })
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

    private func configureNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didShowKeyboard),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willHideKeyboard),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    @objc private func didShowKeyboard(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let height = keyboardFrame.cgRectValue.height
        constraint?.isActive = false
        constraint = stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor,
                                                       constant: -height)
        constraint?.isActive = true
    }

    @objc private func willHideKeyboard(_ notification: Notification) {
        self.constraint?.isActive = false
        self.constraint = self.stackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor,
                                                                 constant: 0)
        self.constraint?.isActive = true
    }
}

extension CreateViewController {
    private func presentAlert() {
        let message = self.viewModel?.buttonType.value.confirmMessage
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel?.didTappedAlertConfirm()
            self.navigationController?.popViewController(animated: true)
        }

        alert.addAction(confirm)
        present(alert, animated: true, completion: nil)
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

    func didTappedCategoryButton() {
        let alert = categoryView.categoryAction
        present(alert, animated: true, completion: nil)
    }
}

extension CreateViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let offset = textField.superview?.frame.origin.y else { return }
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5) {
                self.scrollView.setContentOffset(CGPoint(x: 0, y: offset), animated: false)
            }
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        guard let offset = textView.superview?.frame.origin.y else { return }
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5) {
                self.scrollView.setContentOffset(CGPoint(x: 0, y: offset), animated: false)
            }
        }
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let viewModel = viewModel else { return }
        switch textField.tag {
        case InputTag.title.rawValue:
            viewModel.update(title: textField.text ?? "")
        case InputTag.week.rawValue:
            let week = viewModel.validateWeek(currentText: textField.text ?? "")
            textField.text = week
            viewModel.update(week: Int(week) ?? 0)
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

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
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

    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
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
        textField.endEditing(true)
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
#if targetEnvironment(simulator)
            let alert = UIAlertController(title: "알림",
                                          message: "시뮬레이터에서는 카메라를 이용할 수 없습니다.",
                                          preferredStyle: .alert)
            let cancel = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
#else
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
#endif
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
        if let originalImage = info[InfoKey.originalImage] as? UIImage {
            let mainImage = originalImage.resizedImage(.original)
            let thumbnailImage = originalImage.resizedImage(.thumbnail)

            switch selectedImagePickerTag {
            case .image:
                let mainImageURL = viewModel?.saveImage(to: "temp",
                                                        filename: "image",
                                                        data: mainImage.jpegData(compressionQuality: 0.9))
                let thumbnailImageURL = viewModel?.saveImage(to: "temp",
                                                             filename: "thumbnail_image",
                                                             data: thumbnailImage.jpegData(compressionQuality: 0.9))
                viewModel?.update(imageURL: mainImageURL)
                viewModel?.update(thumbnailImageURL: thumbnailImageURL)
                imageRegisterView.setImage(thumbnailImage)
            case .authImage:
                let mainImageURL = viewModel?.saveImage(to: "temp",
                                                        filename: "auth_method",
                                                        data: mainImage.jpegData(compressionQuality: 0.9))
                let thumbnailImageURL = viewModel?.saveImage(to: "temp",
                                                             filename: "thumbnail_auth_method",
                                                             data: thumbnailImage.jpegData(compressionQuality: 0.9))
                viewModel?.update(authExampleImageURL: mainImageURL)
                viewModel?.update(authExampleThumbnailImageURL: thumbnailImageURL)
                authImageRegisterView.setImage(thumbnailImage)

            default:
                break
            }
        }
        dismiss(animated: true, completion: nil)
    }
}
