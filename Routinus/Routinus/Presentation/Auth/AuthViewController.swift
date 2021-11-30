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
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollView.removeAfterimage()
    }
}

extension AuthViewController {
    private func configure() {
        configureViews()
        configureViewModel()
        configureDelegates()
        configureRefreshControl()
    }

    private func configureViews() {
        let smallWidth = UIScreen.main.bounds.width <= 350
        let offset = smallWidth ? 15.0 : 20.0

        view.backgroundColor = .systemBackground
        scrollView.showsVerticalScrollIndicator = false
        navigationItem.largeTitleDisplayMode = .never

        view.addSubview(scrollView)
        scrollView.anchor(edges: view)

        view.addSubview(authView)
        authView.anchor(horizontal: authView.superview,
                        bottom: view.bottomAnchor,
                        height: smallWidth ? 60 : 90)

        authView.addSubview(authButton)
        authButton.anchor(horizontal: authButton.superview,
                          paddingHorizontal: offset,
                          top: authButton.superview?.topAnchor,
                          paddingTop: 10,
                          bottom: authButton.superview?.bottomAnchor,
                          paddingBottom: smallWidth ? 10 : 30)

        scrollView.addSubview(stackView)
        stackView.anchor(centerX: scrollView.centerXAnchor,
                         horizontal: scrollView,
                         top: scrollView.topAnchor,
                         bottom: scrollView.bottomAnchor,
                         paddingBottom: smallWidth ? 70 : 100)

        stackView.addArrangedSubview(authMethodView)

        stackView.addArrangedSubview(previewView)
        previewView.anchor(height: view.frame.width - offset*2)
    }

    private func configureViewModel() {
        viewModel?.challenge
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

        viewModel?.authButtonState
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] isEnabled in
                guard let self = self else { return }
                self.authButton.updateEnabled(isEnabled: isEnabled)
            })
            .store(in: &cancellables)
    }

    private func configureDelegates() {
        imagePicker.delegate = self
        previewView.delegate = self
        authButton.delegate = self
        authMethodView.delegate = self
    }

    private func configureRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(
            string: "swipe".localized,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray,
                         NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        )
        scrollView.refreshControl = refreshControl
    }

    @objc private func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
            guard let self = self,
                  let viewModel = self.viewModel,
                  let challengeID = viewModel.challenge.value?.challengeID else { return }
            viewModel.fetchChallenge(challengeID: challengeID)
            self.scrollView.refreshControl?.endRefreshing()
        }
    }
}

extension AuthViewController: PreviewViewDelegate {
    func didTappedPreviewView() {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
}

extension AuthViewController: AuthButtonDelegate {
    func didTappedAuthButton() {
        viewModel?.didTappedAuthButton()
        navigationController?.popViewController(animated: true)
    }
}

extension AuthViewController: AuthMethodViewDelegate {
    func didTappedAuthMethodImageView() {
        guard let challengeID = viewModel?.challenge.value?.challengeID else { return }
        guard let thumbnailImage = self.authMethodView.authThumbnailImage else { return }
        viewModel?.didTappedAuthMethodImage(image: thumbnailImage)
        viewModel?.imageData(from: challengeID, filename: "auth_method") { [weak self] data in
            guard let self = self,
                  let data = data else { return }
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

            let mainImageURL = viewModel.saveImage(
                to: "temp",
                filename: "auth",
                data: mainImage.jpegData(compressionQuality: 0.9)
            )
            let thumbnailImageURL = viewModel.saveImage(
                to: "temp",
                filename: "thumbnail_auth",
                data: thumbnailImage.jpegData(compressionQuality: 0.9)
            )
            self.viewModel?.update(userAuthImageURL: mainImageURL)
            self.viewModel?.update(userAuthThumbnailImageURL: thumbnailImageURL)
            previewView.setImage(mainImage)
        }
        dismiss(animated: true, completion: nil)
    }
}
