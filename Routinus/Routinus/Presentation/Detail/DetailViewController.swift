//
//  DetailViewController.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/02.
//

import Combine
import UIKit

final class DetailViewController: UIViewController {

    private lazy var scrollView: UIScrollView = UIScrollView()
    private lazy var stackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 1
        stackView.backgroundColor = UIColor(named: "LightGray")
        return stackView
    }()

    private lazy var editBarButtonItem: UIBarButtonItem = {
        var barButtonItem = UIBarButtonItem()
        barButtonItem.image = UIImage(systemName: "pencil")
        barButtonItem.tintColor = .black
        barButtonItem.target = self
        barButtonItem.action = #selector(didTappedEditBarButton(_:))
        return barButtonItem
    }()

    private lazy var mainImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.backgroundColor = .systemBackground
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var participantView: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private lazy var informationView = InformationView()
    private lazy var authMethodView = AuthMethodView()
    private lazy var participantButton = ParticipantButton()

    private var viewModel: DetailViewModelIO?
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViews()
        self.configureViewModel()
        self.configureDelegate()
    }

    init(with viewModel: DetailViewModelIO) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func configureViews() {
        self.view.backgroundColor = .white
        self.configureNavigationBar()

        view.addSubview(scrollView)
        scrollView.anchor(horizontal: view,
                          top: view.safeAreaLayoutGuide.topAnchor)

        view.addSubview(participantView)
        participantView.anchor(horizontal: participantView.superview,
                               top: scrollView.bottomAnchor,
                               bottom: view.bottomAnchor,
                               height: 90)

        participantView.addSubview(participantButton)
        participantButton.anchor(horizontal: participantButton.superview, paddingHorizontal: 20,
                                 top: participantButton.superview?.topAnchor, paddingTop: 10,
                                 bottom: participantButton.superview?.bottomAnchor, paddingBottom: 30)

        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true

        stackView.addArrangedSubview(mainImageView)
        self.mainImageView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        self.mainImageView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        self.mainImageView.heightAnchor.constraint(equalTo: mainImageView.widthAnchor, multiplier: 1).isActive = true

        stackView.addArrangedSubview(informationView)
        stackView.addArrangedSubview(authMethodView)
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
                self.viewModel?.imageData(from: challenge.challengeID,
                                          filename: "image",
                                          completion: { data in
                    guard let data = data else { return }
                    guard let image = UIImage(data: data) else { return }
                    DispatchQueue.main.async {
                        self.mainImageView.image = image
                    }
                })
                self.informationView.update(to: challenge)
                self.authMethodView.update(to: challenge.authMethod)
                self.viewModel?.imageData(from: challenge.challengeID,
                                          filename: "thumbnail_auth",
                                          completion: { data in
                    guard let data = data else { return }
                    DispatchQueue.main.async {
                        self.authMethodView.update(to: data)
                    }
                })
            })
            .store(in: &cancellables)

        self.viewModel?.ownerState
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] ownerState in
                guard let self = self else { return }
                let rightBarButtonItem = ownerState ? self.editBarButtonItem : nil
                self.navigationItem.rightBarButtonItem = rightBarButtonItem
            })
            .store(in: &cancellables)

        self.viewModel?.participationAuthState
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] participationState in
                guard let self = self else { return }
                self.participantButton.update(to: participationState)
            })
            .store(in: &cancellables)

        self.viewModel?.participationButtonTap
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.presentAlert()
            })
            .store(in: &cancellables)
    }

    private func configureDelegate() {
        participantButton.delegate = self
    }

    private func presentAlert() {
        let alert = UIAlertController(title: "알림", message: "챌린지에 참여되었습니다.", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default, handler: nil)

        alert.addAction(confirm)
        present(alert, animated: true, completion: nil)
    }

    @objc private func didTappedEditBarButton(_ sender: UIBarButtonItem) {
        viewModel?.didTappedEditBarButton()
    }
}

extension DetailViewController: ParticipantButtonDelegate {
    func didTappedParticipantButton() {
        viewModel?.didTappedParticipationAuthButton()
    }
}
