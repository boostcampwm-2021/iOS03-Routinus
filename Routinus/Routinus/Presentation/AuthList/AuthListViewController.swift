//
//  AuthListViewController.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/24.
//

import Combine
import UIKit

class AuthListViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(AuthListCollectionViewCell.self,
                                forCellWithReuseIdentifier: AuthListCollectionViewCell.identifier)
        return collectionView
    }()


    private var viewModel: AuthListViewModelIO?
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: AuthListViewModelIO) {
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
        configureViewModels()
    }
}

extension AuthListViewController {
    private func configureViews() {
        self.view.backgroundColor = .systemBackground

        self.view.addSubview(collectionView)

        collectionView.anchor(leading: view.leadingAnchor, paddingLeading: 10,
                              trailing: view.trailingAnchor, paddingTrailing: 10,
                              top: view.topAnchor, paddingTop: 10,
                              bottom: view.bottomAnchor, paddingBottom: 10)
    }

    private func configureDelegates() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }

    private func configureViewModels() {
        self.viewModel?.authDisplayState
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] state in
                guard let self = self else { return }
                self.navigationItem.title = state.title
            })
            .store(in: &cancellables)

        self.viewModel?.auths
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] auths in
                guard let self = self else { return }
                if auths.isEmpty {
                    self.collectionView.setEmptyView()
                } else {
                    self.collectionView.restore()
                    self.collectionView.reloadData()
                }
            })
            .store(in: &cancellables)
    }
}

extension AuthListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.auths.value.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AuthListCollectionViewCell.identifier,
                                                            for: indexPath) as? AuthListCollectionViewCell else { return UICollectionViewCell() }

        guard let auth = viewModel?.auths.value[indexPath.item], let date = auth.date?.toDateString() else { return UICollectionViewCell() }
        let filename = "\(auth.userID)_\(date)_thumbnail_auth"
        viewModel?.imageData(from: auth.challengeID,
                            filename: filename) { data in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                cell.update(image: image)
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfCells: CGFloat = 2
        let minimumInteritemSpacing: CGFloat = 10
        let width = collectionView.frame.size.width - (minimumInteritemSpacing * (numberOfCells-1))
        return CGSize(width: width/numberOfCells, height: width/numberOfCells)
    }
}
