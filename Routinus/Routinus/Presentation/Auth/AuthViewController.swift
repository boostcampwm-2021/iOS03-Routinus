//
//  AuthViewController.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/02.
//

import Combine
import UIKit

final class AuthViewController: UIViewController {
    private lazy var scrollView: UIScrollView = UIScrollView()
    private lazy var stackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 30
        return stackView
    }()
    private lazy var authView: UIView = {
        var view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    private lazy var authMethodView = AuthMethodView()
    private lazy var previewView = PreviewView()
    private lazy var authButton = AuthButton()

    private var viewModel: AuthViewModelIO?
    private var cancellables = Set<AnyCancellable>()
    private var imagePicker = UIImagePickerController()

    init(viewModel: AuthViewModelIO) {
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
}

extension AuthViewController {
    private func configureViews() {
        self.view.backgroundColor = .systemBackground
        self.configureNavigationBar()

        self.view.addSubview(scrollView)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true

        self.view.addSubview(authView)
        authView.anchor(horizontal: authView.superview,
                        top: scrollView.bottomAnchor,
                        bottom: view.bottomAnchor,
                        height: 90)

        self.authView.addSubview(authButton)
        authButton.anchor(horizontal: authButton.superview, paddingHorizontal: 20,
                          top: authButton.superview?.topAnchor, paddingTop: 10,
                          bottom: authButton.superview?.bottomAnchor, paddingBottom: 30)

        self.scrollView.addSubview(stackView)
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        self.stackView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: -20).isActive = true
        self.stackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
        self.stackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor).isActive = true
        self.stackView.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor).isActive = true

        self.stackView.addArrangedSubview(authMethodView)

        self.stackView.addArrangedSubview(previewView)
        self.previewView.translatesAutoresizingMaskIntoConstraints = false
        self.previewView.heightAnchor.constraint(equalTo: self.previewView.widthAnchor, multiplier: 1).isActive = true
    }

    private func configureNavigationBar() {
        self.navigationItem.largeTitleDisplayMode = .never
    }

    private func configureViewModel() {
        self.viewModel?.challenge
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] challenge in
                guard let self = self,
                      let challenge = challenge else { return }
                self.navigationItem.title = challenge.title
                self.authMethodView.configureMethodLabel(introduction: challenge.introduction)
                self.viewModel?.imageData(from: challenge.challengeID,
                                          filename: "thumbnail_auth",
                                          completion: { data in
                    DispatchQueue.main.async {
                        self.authMethodView.configureMethodImage(data: data)
                    }
                })
            })
            .store(in: &cancellables)

        self.viewModel?.authButtonState
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] isEnabled in
                guard let self = self else { return }
                self.authButton.configureEnabled(isEnabled: isEnabled)
            })
            .store(in: &cancellables)
    }

    private func configureDelegates() {
        self.imagePicker.delegate = self
        self.previewView.delegate = self
        self.authButton.delegate = self
    }
}

extension AuthViewController: PreviewViewDelegate {
    func didTappedPreviewView() {
        self.imagePicker.sourceType = .camera
        self.present(self.imagePicker, animated: true, completion: nil)
    }
}

extension AuthViewController: AuthButtonDelegate {
    func didTappedAuthButton() {
        self.viewModel?.didTappedAuthButton()
        self.navigationController?.popViewController(animated: true) 
    }
}

extension AuthViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    typealias InfoKey = UIImagePickerController.InfoKey

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [InfoKey: Any]) {
        if let originalImage = info[InfoKey.originalImage] as? UIImage {
            let mainImage = originalImage.resizedImage(.original)
            let thumbnailImage = originalImage.resizedImage(.thumbnail)

            let mainImageURL = viewModel?.saveImage(to: "temp",
                                                    filename: "userAuth",
                                                    data: mainImage.jpegData(compressionQuality: 0.9))
            let thumbnailImageURL = viewModel?.saveImage(to: "temp",
                                                         filename: "thumbnail_userAuth",
                                                         data: thumbnailImage.jpegData(compressionQuality: 0.9))
            self.viewModel?.update(userAuthImageURL: mainImageURL)
            self.viewModel?.update(userAuthThumbnailImageURL: thumbnailImageURL)
            previewView.setImage(mainImage)
        }
        dismiss(animated: true, completion: nil)
    }
}
