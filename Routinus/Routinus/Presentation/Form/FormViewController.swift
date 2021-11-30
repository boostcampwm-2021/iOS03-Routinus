//
//  FormViewController.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/02.
//

import AVFoundation
import Combine
import UIKit

final class FormViewController: UIViewController {
    enum InputTag: Int {
        case category = 0, title, image, week, introduction, authMethod, authImage
    }

    typealias InfoKey = UIImagePickerController.InfoKey

    private lazy var scrollView: UIScrollView = UIScrollView()
    private lazy var stackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 35
        return stackView
    }()
    private lazy var categoryView = FormCategoryView()
    private lazy var titleView = FormTitleView()
    private lazy var imageRegisterView = FormImageRegisterView()
    private lazy var weekView = FormWeekView()
    private lazy var introductionView = FormIntroductionView()
    private lazy var authMethodView = FormAuthMethodView()
    private lazy var authImageRegisterView = FormAuthImageRegisterView()
    private lazy var completeButton: UIButton = {
        var button = UIButton()
        button.setTitle(ButtonType.create.rawValue.localized, for: .normal)
        button.setTitleColor(UIColor(named: "Black"), for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.backgroundColor = UIColor(named: "MainColor")
        button.layer.cornerRadius = 20
        button.isEnabled = false
        button.alpha = 0.5
        button.addTarget(self, action: #selector(didTappedCompleteButton(_:)), for: .touchUpInside)
        return button
    }()

    private var viewModel: FormViewModelIO?
    private var cancellables = Set<AnyCancellable>()
    private var imagePicker = UIImagePickerController()
    private var selectedImagePickerTag: InputTag?
    private var constraint: NSLayoutConstraint?

    init(with viewModel: FormViewModelIO) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

extension FormViewController {
    private func configure() {
        configureViews()
        configureViewModel()
        configureDelegates()
        configureGesture()
        configureNotifications()
    }

    private func configureViews() {
        view.backgroundColor = UIColor(named: "SystemBackground")

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
        stackView.addArrangedSubview(completeButton)
        completeButton.anchor(height: 55)
    }

    private func configureViewModel() {
        viewModel?.buttonType
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] buttonType in
                guard let self = self else { return }
                self.completeButton.setTitle(buttonType.rawValue.localized, for: .normal)
            })
            .store(in: &cancellables)

        viewModel?.buttonState
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] isEnabled in
                guard let self = self else { return }
                self.completeButton.isEnabled = isEnabled
                self.completeButton.alpha = isEnabled ? 1 : 0.5
            })
            .store(in: &cancellables)

        viewModel?.expectedEndDate
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] endDate in
                guard let self = self else { return }
                self.weekView.updateEndDate(date: endDate)
            })
            .store(in: &cancellables)

        viewModel?.challenge
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
                        self.imageRegisterView.updateImage(image)
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
                        self.authImageRegisterView.updateImage(image)
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
        let recognizer = UITapGestureRecognizer(target: self,
                                                action: #selector(didTappedScrollView(_:)))
        scrollView.addGestureRecognizer(recognizer)
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

    private func impactLight() {
        let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        impactFeedbackGenerator.impactOccurred()
    }

    @objc private func didTappedScrollView(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended else { return }
        titleView.hideKeyboard()
        weekView.hideKeyboard()
        introductionView.hideKeyboard()
        authMethodView.hideKeyboard()
    }

    @objc private func didTappedCompleteButton(_ sender: UIButton) {
        viewModel?.didTappedCompleteButton()
        navigationController?.popViewController(animated: true)
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
        let stackViewHeight = stackView.frame.size.height
        let scrollViewHeight = scrollView.frame.size.height
        let animationCallOffset = stackViewHeight - scrollViewHeight

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.5) {
                if self.scrollView.contentOffset.y > animationCallOffset {
                    self.scrollView.setContentOffset(CGPoint(x: 0, y: animationCallOffset + 20),
                                                     animated: false)
                }
            } completion: { _ in
                self.constraint?.isActive = false
                self.constraint = self.stackView.bottomAnchor.constraint(
                    equalTo: self.scrollView.bottomAnchor,
                    constant: 0
                )
                self.constraint?.isActive = true
            }
        }
    }
}

extension FormViewController: FormSubviewDelegate {
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

extension FormViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let offset = textField.superview?.frame.origin.y else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
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

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
}

extension FormViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard let offset = textView.superview?.frame.origin.y else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.5) {
                self.scrollView.setContentOffset(CGPoint(x: 0, y: offset), animated: false)
            }
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

    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        guard let viewModel = viewModel, let currentText = textView.text else { return true }
        switch textView.tag {
        case InputTag.introduction.rawValue:
            let isValidate = viewModel.validateTextView(currentText: currentText,
                                                        range: range,
                                                        text: text)
            if !isValidate {
                impactLight()
            }
            return isValidate
        case InputTag.authMethod.rawValue:
            let isValidate = viewModel.validateTextView(currentText: currentText,
                                                        range: range,
                                                        text: text)
            if !isValidate {
                impactLight()
            }
            return isValidate
        default:
            return true
        }
    }
}

extension FormViewController: FormImagePickerDelegate {
    func didTappedImageView(_ tag: Int) {
        var title = ""

        switch tag {
        case InputTag.image.rawValue:
            title = "add challenge main image".localized
            selectedImagePickerTag = .image
        case InputTag.authImage.rawValue:
            title = "add auth method image".localized
            selectedImagePickerTag = .authImage
        default:
            return
        }

        let alert = UIAlertController(title: title.localized,
                                      message: "select camera or album".localized,
                                      preferredStyle: .actionSheet)

        let photo = UIAlertAction(title: "photo".localized, style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        alert.addAction(photo)

        let camera = UIAlertAction(title: "camera".localized, style: .default) { [weak self] _ in
            guard let self = self else { return }
#if targetEnvironment(simulator)
            let simulatorAlert = self.simulatorAlert()
            self.present(simulatorAlert, animated: true, completion: nil)
#else
            let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            if status == .denied {
                let authDeniedAlert = self.authDeniedAlert()
                self.present(authDeniedAlert, animated: true, completion: nil)
            } else {
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true, completion: nil)
            }
#endif
        }
        alert.addAction(camera)

        let cancel = UIAlertAction(title: "cancel".localized, style: .destructive, handler: nil)
        alert.addAction(cancel)

        present(alert, animated: true, completion: nil)
    }

    private func simulatorAlert() -> UIAlertController {
        let alert = UIAlertController(title: "alarm".localized,
                                      message: "simulator is not allowed".localized,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok".localized, style: .default, handler: nil)
        alert.addAction(okAction)
        return alert
    }

    private func authDeniedAlert() -> UIAlertController {
        let alert = UIAlertController(title: "alarm".localized,
                                      message: "no camera permission".localized,
                                      preferredStyle: .alert)
        let ok = UIAlertAction(title: "ok".localized, style: .default, handler: nil)
        let moveSettings = UIAlertAction(title: "go to settings".localized, style: .default) { _ in
            let settingsURL = UIApplication.openSettingsURLString
            guard let appBundleID = Bundle.main.bundleIdentifier,
                  let url = URL(string: "\(settingsURL)\(appBundleID)"),
                  UIApplication.shared.canOpenURL(url) else { return }
            UIApplication.shared.open(url)
        }
        alert.addAction(ok)
        alert.addAction(moveSettings)
        return alert
    }
}

extension FormViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [InfoKey: Any]) {
        if let originalImage = info[InfoKey.originalImage] as? UIImage {
            let mainImage = originalImage.resizedImage(.original)
            let thumbnailImage = originalImage.resizedImage(.thumbnail)

            switch selectedImagePickerTag {
            case .image:
                let mainImageURL = viewModel?.saveImage(
                    to: "temp",
                    filename: "image",
                    data: mainImage.jpegData(compressionQuality: 0.9)
                )
                let thumbnailImageURL = viewModel?.saveImage(
                    to: "temp",
                    filename: "thumbnail_image",
                    data: thumbnailImage.jpegData(compressionQuality: 0.9)
                )
                viewModel?.update(imageURL: mainImageURL)
                viewModel?.update(thumbnailImageURL: thumbnailImageURL)
                imageRegisterView.updateImage(thumbnailImage)
            case .authImage:
                let mainImageURL = viewModel?.saveImage(
                    to: "temp",
                    filename: "auth_method",
                    data: mainImage.jpegData(compressionQuality: 0.9)
                )
                let thumbnailImageURL = viewModel?.saveImage(
                    to: "temp",
                    filename: "thumbnail_auth_method",
                    data: thumbnailImage.jpegData(compressionQuality: 0.9)
                )
                viewModel?.update(authExampleImageURL: mainImageURL)
                viewModel?.update(authExampleThumbnailImageURL: thumbnailImageURL)
                authImageRegisterView.updateImage(thumbnailImage)

            default:
                break
            }
        }
        dismiss(animated: true, completion: nil)
    }
}
