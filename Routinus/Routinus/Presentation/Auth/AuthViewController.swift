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
    private lazy var authMethodView = AuthMethodView()
    private lazy var previewView = PreviewView()
    private lazy var authButton = AuthButton()
    
    private var viewModel: AuthViewModelIO?
    private var cancellables = Set<AnyCancellable>()

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
        self.stackView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 20).isActive = true
        self.stackView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -20).isActive = true
        self.stackView.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor).isActive = true

        self.stackView.addArrangedSubview(authMethodView)
        self.authMethodView.translatesAutoresizingMaskIntoConstraints = false
        self.authMethodView.heightAnchor.constraint(equalToConstant: 240).isActive = true

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

    private func configureViewModel() {
        self.viewModel?.challenge
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] challenge in
                guard let self = self else { return }
                self.navigationItem.title = challenge.title
            })
            .store(in: &cancellables)
    }
}
