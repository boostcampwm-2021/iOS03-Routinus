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
        barButtonItem.tintColor = UIColor(named: "Black")
        barButtonItem.target = self
        barButtonItem.action = #selector(didTappedEditBarButton(_:))
        return barButtonItem
    }()

    private lazy var mainImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.backgroundColor = .systemBackground
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var participantView: UIView = {
        var view = UIView()
        view.backgroundColor = .systemBackground.withAlphaComponent(0.7)
        return view
    }()

    private lazy var informationView = InformationView()
    private lazy var authMethodView = AuthMethodView()
    private lazy var participantButton = ParticipantButton()
    private lazy var detailAuthDisplayListView = DetailAuthDisplayListView()

    private var viewModel: DetailViewModelIO?
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViews()
        self.configureViewModel()
        self.configureDelegate()
        self.configureRefreshControl()
    }

    init(with viewModel: DetailViewModelIO) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func configureViews() {
        let smallWidth = UIScreen.main.bounds.width <= 350
        let offset = smallWidth ? 15.0 : 20.0

        self.view.backgroundColor = .systemBackground
        self.configureNavigationBar()

        view.addSubview(scrollView)
        self.scrollView.anchor(edges: view)

        view.addSubview(participantView)
        participantView.anchor(horizontal: participantView.superview,
                               bottom: view.bottomAnchor,
                               height: smallWidth ? 60 : 90)

        participantView.addSubview(participantButton)
        participantButton.anchor(horizontal: participantView,
                                 paddingHorizontal: offset,
                                 top: participantView.topAnchor,
                                 paddingTop: 10,
                                 bottom: participantView.bottomAnchor,
                                 paddingBottom: smallWidth ? 10 : 30)

        scrollView.addSubview(stackView)
        stackView.anchor(centerX: scrollView.centerXAnchor,
                         horizontal: scrollView,
                         top: scrollView.topAnchor,
                         bottom: scrollView.bottomAnchor,
                         paddingBottom: smallWidth ? 60 : 90)

        stackView.addArrangedSubview(mainImageView)
        mainImageView.anchor(horizontal: stackView,
                             height: UIScreen.main.bounds.width)

        stackView.addArrangedSubview(informationView)
        stackView.addArrangedSubview(authMethodView)
        stackView.addArrangedSubview(detailAuthDisplayListView)
    }

    private func configureNavigationBar() {
        self.navigationItem.largeTitleDisplayMode = .never
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = UIColor(named: "Black")
        self.navigationItem.backBarButtonItem = backBarButtonItem
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
                    guard let data = data,
                          let image = UIImage(data: data) else { return }
                    DispatchQueue.main.async {
                        self.mainImageView.image = image
                    }
                })
                self.informationView.update(to: challenge)
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
                self.viewModel?.updateParticipantCount()
                self.presentAlert()
            })
            .store(in: &cancellables)
    }

    private func configureDelegate() {
        participantButton.delegate = self
        detailAuthDisplayListView.delegate = self
        authMethodView.delegate = self
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
            self.viewModel?.fetchChallenge()
            self.scrollView.refreshControl?.endRefreshing()
        }
    }

    private func presentAlert() {
        let alert = UIAlertController(title: "알림", message: "챌린지에 참여되었습니다.", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default) { _ in
            self.viewModel?.didTappedAlertConfirm()
        }

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

extension DetailViewController: AuthDisplayViewDelegate {
    func didTappedAllAuthDisplayView() {
        self.viewModel?.didTappedAllAuthDisplayView()
    }

    func didTappedMyAuthDisplayView() {
        self.viewModel?.didTappedMyAuthDisplayView()
    }
}

extension DetailViewController: AuthMethodViewDelegate {
    func didTappedAuthMethodImageView() {
        guard let thumbnailImage = authMethodView.authThumbnailImage else { return }
        self.viewModel?.didTappedAuthMethodImage(imageData: thumbnailImage)
        guard let challengeID = viewModel?.challengeID else { return }
        self.viewModel?.imageData(from: challengeID,
                                  filename: "auth_method") { data in
            guard let data = data else { return }
            self.viewModel?.loadAuthMethodImage(imageData: data)
        }
    }
}
