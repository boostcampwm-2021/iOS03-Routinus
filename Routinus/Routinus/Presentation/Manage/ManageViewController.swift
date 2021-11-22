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
        case add, participating, created, ended
    }

    typealias DataSource = UICollectionViewDiffableDataSource<Section, Challenge>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Challenge>

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

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

extension ManageViewController {
    private func configureViews() {
        view.backgroundColor = .systemBackground

        view.addSubview(collectionView)
        collectionView.anchor(edges: view.safeAreaLayoutGuide)
    }

    private func configureViewModel() {
        viewModel?.participatingChallenges
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] challengeItem in
                guard let self = self else { return }
                var snapshot = self.dataSource.snapshot(for: .participating)
                snapshot.deleteAll()
                snapshot.append(challengeItem)
                self.dataSource.apply(snapshot, to: .participating)
            })
            .store(in: &cancellables)

        viewModel?.createdChallenges
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] challengeItem in
                guard let self = self else { return }
                var snapshot = self.dataSource.snapshot(for: .created)
                snapshot.deleteAll()
                snapshot.append(challengeItem)
                self.dataSource.apply(snapshot, to: .created)
            })
            .store(in: &cancellables)

        viewModel?.endedChallenges
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] challengeItem in
                guard let self = self else { return }
                var snapshot = self.dataSource.snapshot(for: .ended)
                snapshot.deleteAll()
                snapshot.append(challengeItem)
                self.dataSource.apply(snapshot, to: .ended)
            })
            .store(in: &cancellables)
    }

    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        dataSource = configureDataSource()
        configureHeader(of: dataSource)

        var snapshot = self.dataSource.snapshot(for: .add)
        snapshot.append([Challenge(challengeID: "",
                                        title: "",
                                        introduction: "",
                                        category: .exercise,
                                        imageURL: "",
                                        thumbnailImageURL: "",
                                        authExampleImageURL: "",
                                        authExampleThumbnailImageURL: "",
                                        authMethod: "",
                                        startDate: Date(),
                                        endDate: Date(),
                                        ownerID: "",
                                        week: 0,
                                        participantCount: 0)])
        dataSource.apply(snapshot, to: .add)
    }

    static func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in
            let layout = ManageCollectionViewLayouts()
            return layout.section(at: sectionNumber)
        }
    }
}

extension ManageViewController: AddChallengeDelegate {
    func didTappedAddButton() {
        viewModel?.didTappedAddButton()
    }

    func didLoadedManageView() {
        viewModel?.didLoadedManageView()
    }
}

extension ManageViewController {
    private func configureDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, content in
            if indexPath.section == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ManageAddCollectionViewCell.identifier,
                                                              for: indexPath) as? ManageAddCollectionViewCell
                cell?.addDelegate(self)
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
        if indexPath.section != 0 {
            viewModel?.didTappedChallenge(index: indexPath)
        }
    }
}

extension ManageViewController: UIGestureRecognizerDelegate {
    @objc func collectionViewHeaderTouched(_ sender: UITapGestureRecognizer) {
        guard let headerView = sender.view as? ManageCollectionViewHeader else { return }

        headerView.didTouchedHeader()
        switch headerView.section {
        case .participating:
            var snapshot = dataSource.snapshot(for: .participating)
            if headerView.isExpanded == true {
                snapshot.append(viewModel?.participatingChallenges.value ?? [])
            } else {
                snapshot.deleteAll()
            }
            dataSource.apply(snapshot, to: .participating)
        case .created:
            var snapshot = dataSource.snapshot(for: .created)
            if headerView.isExpanded == true {
                snapshot.append(viewModel?.createdChallenges.value ?? [])
            } else {
                snapshot.deleteAll()
            }
            dataSource.apply(snapshot, to: .created)
        case .ended:
            var snapshot = dataSource.snapshot(for: .ended)
            if headerView.isExpanded == true {
                snapshot.append(viewModel?.endedChallenges.value ?? [])
            } else {
                snapshot.deleteAll()
            }
            dataSource.apply(snapshot, to: .ended)
        case .none:
            break
        }
    }
}
