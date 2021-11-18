//
//  ManageViewController.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/02.
//

import Combine
import UIKit

final class ManageViewController: UIViewController {
    enum Section: CaseIterable {
        case challenge
    }

    typealias DataSource = UICollectionViewDiffableDataSource<Section, Challenge>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Challenge>

    private lazy var dataSource = configureDataSource()
    private lazy var snapshot = Snapshot()
    private var viewModel: ManageViewModelIO?
    private var cancellables = Set<AnyCancellable>()

    lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                     style: .plain, target: self,
                                     action: #selector(didTouchAddButton))
        button.tintColor = .black
        return button
    }()

    private var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = false

        collectionView.register(ChallengeCollectionViewCell.self,
                                forCellWithReuseIdentifier: ChallengeCollectionViewCell.identifier)

        return collectionView
    }()

    init(with viewModel: ManageViewModelIO) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViews()
        self.configureViewModel()
        self.configureCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.didLoadedSearchView()
    }
}

extension ManageViewController {
    private func configureViews() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(collectionView)
        collectionView.anchor(horizontal: collectionView.superview,
                              vertical: collectionView.superview)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationItem.title = "내가 개설한 챌린지"
        self.navigationItem.rightBarButtonItem = self.addButton
    }

    private func configureViewModel() {
        self.viewModel?.challenges
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] challengeItem in
                guard let self = self else { return }
                var challengeSnapshot = self.dataSource.snapshot(for: Section.challenge)
                let challengeContents = challengeItem
                challengeSnapshot.deleteAll()
                challengeSnapshot.append(challengeContents)
                self.dataSource.apply(challengeSnapshot, to: Section.challenge)
            })
            .store(in: &cancellables)
    }

    private func configureCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = dataSource
        self.snapshot.appendSections(Section.allCases)
        self.dataSource = configureDataSource()
    }

    static func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in
            let layout = ManageCollectionViewLayouts()
            return layout.section(at: sectionNumber)
        }
    }
}

extension ManageViewController {
    @objc func didTouchAddButton() {
        self.viewModel?.didTappedAddButton()
    }

    func didLoadedSearchView() {
        self.viewModel?.didLoadedManageView()
    }
}

extension ManageViewController {
    private func configureDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: self.collectionView) { collectionView, indexPath, challenge in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChallengeCollectionViewCell.identifier,
                                                          for: indexPath) as? ChallengeCollectionViewCell
            cell?.setTitle(challenge.title)
            self.viewModel?.imageData(from: challenge.challengeID,
                                      filename: "thumbnail_image") { data in
                guard let data = data else { return }
                guard let image = UIImage(data: data) else { return }

                DispatchQueue.main.async {
                    cell?.setImage(image)
                }
            }
            return cell
        }
        return dataSource
    }
}

extension ManageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel?.didTappedChallenge(index: indexPath.item)
    }
}
