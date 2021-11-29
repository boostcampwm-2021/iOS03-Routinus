//
//  AuthImagesViewController.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/24.
//

import Combine
import UIKit

class AuthImagesViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(AuthImagesCollectionViewCell.self,
                                forCellWithReuseIdentifier: AuthImagesCollectionViewCell.identifier)
        return collectionView
    }()

    private var viewModel: AuthImagesViewModelIO?
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: AuthImagesViewModelIO) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureDelegates()
        configureViewModel()
        configureRefreshControl()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.removeAfterimage()
    }
}

extension AuthImagesViewController {
    private func configureViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.anchor(leading: view.leadingAnchor,
                              paddingLeading: 10,
                              trailing: view.trailingAnchor,
                              paddingTrailing: 10,
                              top: view.topAnchor,
                              paddingTop: 10,
                              bottom: view.bottomAnchor,
                              paddingBottom: 10)
    }

    private func configureDelegates() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    private func configureViewModel() {
        viewModel?.authDisplayState
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] state in
                guard let self = self else { return }
                self.navigationItem.title = state.title
            })
            .store(in: &cancellables)

        viewModel?.auths
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] auths in
                guard let self = self else { return }
                if auths.isEmpty {
                    self.collectionView.notifyEmptyData()
                } else {
                    self.collectionView.restore()
                    self.collectionView.reloadData()
                }
            })
            .store(in: &cancellables)
    }

    private func configureRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(
            string: "swipe".localized,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray,
                         NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        )
        collectionView.refreshControl = refreshControl
    }

    @objc private func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            guard let authDisplayState = self.viewModel?.authDisplayState.value else { return }
            self.viewModel?.fetchChallengeAuthData(authDisplayState: authDisplayState)
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
}

extension AuthImagesViewController: UICollectionViewDataSource,
                                    UICollectionViewDelegate,
                                    UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel?.auths.value.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AuthImagesCollectionViewCell.identifier,
            for: indexPath) as? AuthImagesCollectionViewCell else { return UICollectionViewCell() }

        guard let auth = viewModel?.auths.value[indexPath.item],
              let date = auth.date?.toDateString() else { return UICollectionViewCell() }
        let filename = "\(auth.userID)_\(date)_thumbnail_auth"
        viewModel?.imageData(from: auth.challengeID, filename: filename) { data in
            guard let data = data,
                  let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                cell.update(image: image)
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCells: CGFloat = 2
        let minimumInteritemSpacing: CGFloat = 10
        let width = collectionView.frame.size.width - (minimumInteritemSpacing * (numberOfCells-1))
        return CGSize(width: width / numberOfCells, height: width / numberOfCells)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath)
                as? AuthImagesCollectionViewCell else { return }
        viewModel?.authImageTap.send(cell.imageData())

        guard let auth = viewModel?.auths.value[indexPath.item],
              let date = auth.date?.toDateString() else { return }
        let filename = "\(auth.userID)_\(date)_auth"
        viewModel?.imageData(from: auth.challengeID, filename: filename) { data in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.viewModel?.authImageLoad.send(data)
            }
        }
    }
}
