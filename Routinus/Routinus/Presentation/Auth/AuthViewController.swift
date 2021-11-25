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
        view.backgroundColor = .systemBackground.withAlphaComponent(0.7)
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
        configureRefreshControl()
    }
}

extension AuthViewController {
    private func configureViews() {
        let smallWidth = UIScreen.main.bounds.width <= 350
        let offset = smallWidth ? 15.0 : 20.0

        self.view.backgroundColor = .systemBackground
        self.scrollView.showsVerticalScrollIndicator = false
        self.configureNavigationBar()

        self.view.addSubview(scrollView)
        self.scrollView.anchor(edges: view)

        self.view.addSubview(authView)
        authView.anchor(horizontal: authView.superview,
                        bottom: view.bottomAnchor,
                        height: smallWidth ? 60 : 90)

        self.authView.addSubview(authButton)
        authButton.anchor(horizontal: authButton.superview, paddingHorizontal: offset,
                          top: authButton.superview?.topAnchor, paddingTop: 10,
                          bottom: authButton.superview?.bottomAnchor, paddingBottom: smallWidth ? 10 : 30)

        self.scrollView.addSubview(stackView)
        self.stackView.anchor(centerX: self.scrollView.centerXAnchor,
                              horizontal: self.scrollView,
                              top: self.scrollView.topAnchor,
                              bottom: self.scrollView.bottomAnchor,
                              paddingBottom: smallWidth ? 70 : 100)

        self.stackView.addArrangedSubview(authMethodView)

        self.stackView.addArrangedSubview(previewView)
        self.previewView.anchor(height: view.frame.width - offset*2)
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
                self.authMethodView.update(to: challenge.authMethod)
                self.viewModel?.imageData(from: challenge.challengeID,
                                          filename: "thumbnail_auth_method",
                                          completion: { data in
                    guard let data = data else { return }
                    DispatchQueue.main.async {
                        self.authMethodView.update(to: data)
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
        self.authMethodView.delegate = self
    }

    private func configureRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                           action: #selector(refresh),
                           for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "swipe".localized,
                                                     attributes: [NSAttributedString.Key.foregroundColor:
                                                                    UIColor.systemGray,
                                                                  NSAttributedString.Key.font:
                                                                    UIFont.boldSystemFont(ofSize: 20)])
        self.scrollView.refreshControl = refreshControl
    }

    @objc private func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            guard let viewModel = self.viewModel,
                  let challengeID = viewModel.challenge.value?.challengeID else { return }
            viewModel.fetchChallenge(challengeID: challengeID)
            self.scrollView.refreshControl?.endRefreshing()
        }
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

extension AuthViewController: AuthMethodViewDelegate {
    func didTappedAuthMethodImageView() {
        guard let challengeID = viewModel?.challenge.value?.challengeID else { return }
        guard let thumbnailImage = self.authMethodView.authThumbnailImage else { return }
        self.viewModel?.didTappedAuthMethodImage(image: thumbnailImage)
        self.viewModel?.imageData(from: challengeID,
                                  filename: "auth_method") { data in
            guard let data = data else { return }
            self.viewModel?.loadedAuthMethodImage(image: data)
        }
    }
}

extension AuthViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    typealias InfoKey = UIImagePickerController.InfoKey

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [InfoKey: Any]) {
        guard let viewModel = viewModel else { return }
        if let originalImage = info[InfoKey.originalImage] as? UIImage {
            var mainImage = originalImage.resizedImage(.original)
            mainImage = mainImage.insertText(name: viewModel.userName,
                                             date: Date().toDateWithWeekdayString(),
                                             time: Date().toTimeColonString())
            let thumbnailImage = mainImage.resizedImage(.thumbnail)

            let mainImageURL = viewModel.saveImage(to: "temp",
                                                   filename: "auth",
                                                   data: mainImage.jpegData(compressionQuality: 0.9))
            let thumbnailImageURL = viewModel.saveImage(to: "temp",
                                                        filename: "thumbnail_auth",
                                                        data: thumbnailImage.jpegData(compressionQuality: 0.9))
            self.viewModel?.update(userAuthImageURL: mainImageURL)
            self.viewModel?.update(userAuthThumbnailImageURL: thumbnailImageURL)
            previewView.setImage(mainImage)
        }
        dismiss(animated: true, completion: nil)
    }
}
