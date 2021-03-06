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
        barButtonItem.tintColor = UIColor(named: "SystemForeground")
        barButtonItem.target = self
        barButtonItem.action = #selector(didTappedEditBarButton(_:))
        return barButtonItem
    }()
    private lazy var mainImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.backgroundColor = UIColor(named: "SystemBackground")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    private lazy var participantView: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor(named: "SystemBackground")?.withAlphaComponent(0.7)
        return view
    }()
    private lazy var informationView = DetailInformationView()
    private lazy var authMethodView = AuthMethodView()
    private lazy var participantButton = DetailParticipantButton()
    private lazy var detailAuthDisplayListView = DetailAuthDisplayListView()

    private var viewModel: DetailViewModelIO?
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scrollView.removeAfterimage()
    }

    init(with viewModel: DetailViewModelIO) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension DetailViewController {
    private func configure() {
        configureViews()
        configureViewModel()
        configureDelegates()
        configureRefreshControl()
    }

    private func configureViews() {
        let smallWidth = UIScreen.main.bounds.width <= 350
        let offset = smallWidth ? 15.0 : 20.0

        view.backgroundColor = UIColor(named: "SystemBackground")

        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = UIColor(named: "SystemForeground")
        navigationItem.backBarButtonItem = backBarButtonItem

        view.addSubview(scrollView)
        scrollView.anchor(edges: view)

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
        mainImageView.anchor(horizontal: stackView, height: UIScreen.main.bounds.width)

        stackView.addArrangedSubview(informationView)
        stackView.addArrangedSubview(authMethodView)
        stackView.addArrangedSubview(detailAuthDisplayListView)
    }

    private func configureViewModel() {
        viewModel?.challenge
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

        viewModel?.ownerState
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] ownerState in
                guard let self = self else { return }
                let rightBarButtonItem = ownerState ? self.editBarButtonItem : nil
                self.navigationItem.rightBarButtonItem = rightBarButtonItem
            })
            .store(in: &cancellables)

        viewModel?.participationAuthState
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] participationState in
                guard let self = self else { return }
                self.participantButton.update(to: participationState)
            })
            .store(in: &cancellables)

        viewModel?.participationButtonTap
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.viewModel?.updateParticipantCount()
                self.presentAlert()
                self.impactLight()
            })
            .store(in: &cancellables)
    }

    private func configureDelegates() {
        participantButton.delegate = self
        detailAuthDisplayListView.delegate = self
        authMethodView.delegate = self
    }

    private func configureRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(
            string: "swipe".localized,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "DayColor") as Any,
                         NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]
        )
        scrollView.refreshControl = refreshControl
    }

    @objc private func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
            guard let self = self else { return }
            self.viewModel?.fetchChallenge()
            self.scrollView.refreshControl?.endRefreshing()
        }
    }

    @objc private func didTappedEditBarButton(_ sender: UIBarButtonItem) {
        viewModel?.didTappedEditBarButton()
    }

    private func presentAlert() {
        let alert = UIAlertController(title: "alarm".localized,
                                      message: "participated".localized,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "ok".localized, style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }

    private func impactLight() {
        let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        impactFeedbackGenerator.impactOccurred()
    }
}

extension DetailViewController: ParticipantButtonDelegate {
    func didTappedParticipantButton() {
        viewModel?.didTappedParticipationAuthButton()
    }
}

extension DetailViewController: AuthDisplayViewDelegate {
    func didTappedAllAuthDisplayView() {
        viewModel?.didTappedAllAuthDisplayView()
    }

    func didTappedMyAuthDisplayView() {
        viewModel?.didTappedMyAuthDisplayView()
    }
}

extension DetailViewController: AuthMethodViewDelegate {
    func didTappedAuthMethodImageView() {
        guard let thumbnailImage = authMethodView.authThumbnailImage else { return }
        viewModel?.didTappedAuthMethodImage(imageData: thumbnailImage)
        guard let challengeID = viewModel?.challengeID else { return }
        viewModel?.imageData(from: challengeID, filename: "auth_method") { [weak self] data in
            guard let self = self,
                  let data = data else { return }
            self.viewModel?.loadedAuthMethodImage(imageData: data)
        }
    }
}
