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
        case participating, created, ended, add
    }

    typealias DataSource = UICollectionViewDiffableDataSource<Section, Challenge>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Challenge>

    private lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                     style: .plain, target: self,
                                     action: #selector(didTouchAddButton))
        button.tintColor = UIColor(named: "Black")
        return button
    }()

    private var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = false

        collectionView.register(ManageCollectionViewHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: ManageCollectionViewHeader.identifier)
        collectionView.register(ChallengeCollectionViewCell.self,
                                forCellWithReuseIdentifier: ChallengeCollectionViewCell.identifier)
        collectionView.register(ManageAddCollectionViewCell.self,
                                forCellWithReuseIdentifier: ManageAddCollectionViewCell.identifier)

        return collectionView
    }()
    private lazy var dataSource = configureDataSource()
    private lazy var snapshot = Snapshot()
    private var viewModel: ManageViewModelIO?
    private var cancellables = Set<AnyCancellable>()

    init(with viewModel: ManageViewModelIO) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureCollectionView()
        configureViewModel()
        didLoadedManageView()
    }
}

extension ManageViewController {
    private func configureViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.anchor(horizontal: collectionView.superview,
                              vertical: collectionView.superview)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "my challenges".localized
        navigationItem.rightBarButtonItem = self.addButton
    }

    private func configureViewModel() {
        self.viewModel?.participatingChallenges
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] challengeItem in
                guard let self = self else { return }
                var snapshot = self.dataSource.snapshot(for: .participating)
                snapshot.append(challengeItem)
                self.dataSource.apply(snapshot, to: .participating)
            })
            .store(in: &cancellables)

        self.viewModel?.createdChallenges
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] challengeItem in
                guard let self = self else { return }
                var snapshot = self.dataSource.snapshot(for: .created)
                snapshot.append(challengeItem)
                self.dataSource.apply(snapshot, to: .created)
            })
            .store(in: &cancellables)

        self.viewModel?.endedChallenges
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] challengeItem in
                guard let self = self else { return }
                var snapshot = self.dataSource.snapshot(for: .ended)
                snapshot.append(challengeItem)
                self.dataSource.apply(snapshot, to: .ended)
            })
            .store(in: &cancellables)
    }

    private func configureCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = dataSource
        self.snapshot.appendSections(Section.allCases)
        self.dataSource = configureDataSource()
        self.configureHeader(of: dataSource)
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

    func didLoadedManageView() {
        self.viewModel?.didLoadedManageView()
    }
}

extension ManageViewController {
    private func configureDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: self.collectionView) { collectionView, indexPath, content in
            if indexPath.section == 3 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ManageAddCollectionViewCell.identifier,
                                                              for: indexPath) as? ManageAddCollectionViewCell
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChallengeCollectionViewCell.identifier,
                                                              for: indexPath) as? ChallengeCollectionViewCell
                cell?.setTitle(content.title)
                self.viewModel?.imageData(from: content.challengeID,
                                          filename: "thumbnail_image") { data in
                    guard let data = data,
                          let image = UIImage(data: data) else { return }

                    DispatchQueue.main.async {
                        cell?.setImage(image)
                    }
                }
                return cell
            }
        }
        return dataSource
    }

    private func configureHeader(of dataSource: DataSource) {
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }

            let view = collectionView.dequeueReusableSupplementaryView(
                                      ofKind: kind,
                                      withReuseIdentifier: ManageCollectionViewHeader.identifier,
                                      for: indexPath) as? ManageCollectionViewHeader
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]

            switch section {
            case .created:
                view?.configureViews(section: .created)
            case .participating:
                view?.configureViews(section: .participating)
            case .ended:
                view?.configureViews(section: .ended)
            case .add:
                break
            }

            if view?.gestureRecognizers?.count == nil {
                let tapGesture = UITapGestureRecognizer(target: self,
                                                        action: #selector(self.collectionViewHeaderTouched(_:)))
                tapGesture.delegate = self
                view?.addGestureRecognizer(tapGesture)
            }

            return view
        }
    }
}

extension ManageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel?.didTappedChallenge(index: indexPath.item)
    }
}

extension ManageViewController: UIGestureRecognizerDelegate {
    @objc func collectionViewHeaderTouched(_ sender: UITapGestureRecognizer) {
        guard let headerView = sender.view as? ManageCollectionViewHeader else { return }
        headerView.didTouchedHeader()
    }
}
