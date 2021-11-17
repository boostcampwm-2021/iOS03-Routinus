//
//  AuthViewController.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/02.
//

import UIKit

final class AuthViewController: UIViewController {
    private lazy var scrollView: UIScrollView = UIScrollView()
    private lazy var stackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 30
        return stackView
    }()
    private lazy var authMethodView = AuthMethodView()
    private lazy var previewView = PreviewView()
    private lazy var authButton = AuthButton()
    private var imagePicker = UIImagePickerController()

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        configureDelegates()
    }
}

extension AuthViewController {
    private func configureViews() {
        self.view.backgroundColor = .white
        self.configureNavigationBar()

        self.view.addSubview(scrollView)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true

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

        self.stackView.addArrangedSubview(authButton)
        self.authButton.translatesAutoresizingMaskIntoConstraints = false
        self.authButton.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        self.authButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    private func configureNavigationBar() {
        self.navigationItem.largeTitleDisplayMode = .never
    }

    private func configureDelegates() {
        self.imagePicker.delegate = self
        self.previewView.delegate = self
    }
}

extension AuthViewController: PreviewViewDelegate {
    func didTappedPreview() {
        self.imagePicker.sourceType = .camera
        self.present(self.imagePicker, animated: true, completion: nil)
    }
}

extension AuthViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    typealias InfoKey = UIImagePickerController.InfoKey

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [InfoKey: Any]) {
        if let originalImage = info[InfoKey.originalImage] as? UIImage {
            let mainImage = originalImage.resizedImage(.main)
            let thumbnailImage = originalImage.resizedImage(.thumbnail)
            
//            let mainImageURL = viewModel?.saveImage(to: "temp",
//                                                    filename: "auth",
//                                                    data: mainImage.jpegData(compressionQuality: 0.9))
//            let thumbnailImageURL = viewModel?.saveImage(to: "temp",
//                                                         filename: "thumbnail_auth",
//                                                         data: thumbnailImage.jpegData(compressionQuality: 0.9))
//            viewModel?.update(authExampleImageURL: mainImageURL)
//            viewModel?.update(authExampleThumbnailImageURL: thumbnailImageURL)
            previewView.setImage(thumbnailImage)
        }
        dismiss(animated: true, completion: nil)
    }
}
