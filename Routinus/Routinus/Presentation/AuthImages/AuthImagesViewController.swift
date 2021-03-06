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
        configure()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.removeAfterimage()
    }
}

extension AuthImagesViewController {
    private func configure() {
        configureViews()
        configureViewModel()
        configureDelegates()
    }

    private func configureViews() {
        view.backgroundColor = UIColor(named: "SystemBackground")
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

    private func configureDelegates() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension AuthImagesViewController: UICollectionViewDataSource {
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
}

extension AuthImagesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath)
                as? AuthImagesCollectionViewCell else { return }
        viewModel?.authImageTap.send(cell.imageData())

        guard let auth = viewModel?.auths.value[indexPath.item],
              let date = auth.date?.toDateString() else { return }
        let filename = "\(auth.userID)_\(date)_auth"
        viewModel?.imageData(from: auth.challengeID, filename: filename) { data in
            guard let data = data else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.viewModel?.authImageLoad.send(data)
            }
        }
    }
}

extension AuthImagesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCells: CGFloat = 2
        let minimumInteritemSpacing: CGFloat = 10
        let width = collectionView.frame.size.width - (minimumInteritemSpacing * (numberOfCells-1))
        return CGSize(width: width / numberOfCells, height: width / numberOfCells)
    }
}
