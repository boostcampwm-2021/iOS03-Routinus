//
//  ManageViewController.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/02.
//

import Combine
import UIKit

final class ManageViewController: UIViewController {
    enum Section: Int, CaseIterable {
        case add = 0, participating, created, ended
    }

    enum Item: Hashable {
        case title
        case challenge(Challenge)
    }

    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    private var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.showsVerticalScrollIndicator = false

        collectionView.register(
            ManageCollectionViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ManageCollectionViewHeader.identifier
        )
        collectionView.register(
            ChallengeCollectionViewCell.self,
            forCellWithReuseIdentifier: ChallengeCollectionViewCell.identifier
        )
        collectionView.register(
            ManageAddCollectionViewCell.self,
            forCellWithReuseIdentifier: ManageAddCollectionViewCell.identifier
        )

        return collectionView
    }()

    private var dataSource: DataSource?
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
        configure()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        collectionView.removeAfterimage()
        expandHeaders()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    static func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in
            let layout = ManageCollectionViewLayouts()
            return layout.section(at: sectionNumber)
        }
    }
}

extension ManageViewController {
    private func configure() {
        configureViews()
        configureCollectionView()
        configureViewModel()
        configureDelegates()
        configureTitle()
        configureRefreshControl()
    }

    private func configureViews() {
        view.backgroundColor = .systemBackground

        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = UIColor(named: "Black")
        navigationItem.backBarButtonItem = backBarButtonItem

        view.addSubview(collectionView)
        collectionView.anchor(edges: view.safeAreaLayoutGuide)
    }

    private func configureCollectionView() {
        dataSource = configureDataSource()
        configureHeader(of: dataSource)
    }

    private func configureHeader(of dataSource: DataSource?) {
        dataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self = self,
                  let dataSource = self.dataSource,
                  kind == UICollectionView.elementKindSectionHeader else { return nil }

            let view = collectionView.dequeueReusableSupplementaryView(
                                      ofKind: kind,
                                      withReuseIdentifier: ManageCollectionViewHeader.identifier,
                                      for: indexPath) as? ManageCollectionViewHeader
            let section = dataSource.snapshot().sectionIdentifiers[indexPath.section]

            switch section {
            case .created:
                view?.updateViews(section: .created)
            case .participating:
                view?.updateViews(section: .participating)
            case .ended:
                view?.updateViews(section: .ended)
            case .add:
                break
            }

            if view?.gestureRecognizers?.count == nil {
                let tapGesture = UITapGestureRecognizer(
                    target: self,
                    action: #selector(self.collectionViewHeaderTouched(_:))
                )
                tapGesture.delegate = self
                view?.addGestureRecognizer(tapGesture)
            }

            return view
        }
    }

    private func configureViewModel() {
        viewModel?.participatingChallenges
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] challengeItem in
                guard let self = self,
                      let dataSource = self.dataSource else { return }
                let contents = challengeItem.map { Item.challenge($0) }
                var snapshot = dataSource.snapshot(for: .participating)
                snapshot.deleteAll()
                snapshot.append(contents)
                dataSource.apply(snapshot, to: .participating)
            })
            .store(in: &cancellables)

        viewModel?.createdChallenges
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] challengeItem in
                guard let self = self,
                      let dataSource = self.dataSource else { return }
                let contents = challengeItem.map { Item.challenge($0) }
                var snapshot = dataSource.snapshot(for: .created)
                snapshot.deleteAll()
                snapshot.append(contents)
                dataSource.apply(snapshot, to: .created)
            })
            .store(in: &cancellables)

        viewModel?.endedChallenges
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] challengeItem in
                guard let self = self,
                      let dataSource = self.dataSource  else { return }
                let contents = challengeItem.map { Item.challenge($0) }
                var snapshot = dataSource.snapshot(for: .ended)
                snapshot.deleteAll()
                snapshot.append(contents)
                dataSource.apply(snapshot, to: .ended)
            })
            .store(in: &cancellables)
    }

    private func configureDelegates() {
        collectionView.delegate = self
        collectionView.dataSource = dataSource
    }

    private func configureTitle() {
        guard var snapshot = dataSource?.snapshot(for: .add) else { return }
        snapshot.append([Item.title])
        dataSource?.apply(snapshot, to: .add)
    }

    private func configureRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(
            string: "swipe".localized,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray,
                         NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]
        )
        collectionView.refreshControl = refreshControl
    }

    private func configureDataSource() -> DataSource? {
        let dataSource = DataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, content in
            guard let self = self else { return nil }
            switch content {
            case .title:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ManageAddCollectionViewCell.identifier,
                    for: indexPath
                ) as? ManageAddCollectionViewCell
                cell?.delegate = self
                return cell

            case .challenge(let challenge):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ChallengeCollectionViewCell.identifier,
                    for: indexPath
                ) as? ChallengeCollectionViewCell
                cell?.updateTitle(challenge.title)
                self.viewModel?.imageData(from: challenge.challengeID,
                                          filename: "thumbnail_image") { data in
                    guard let data = data,
                          let image = UIImage(data: data) else { return }

                    DispatchQueue.main.async {
                        cell?.updateImage(image)
                    }
                }
                return cell
            }
        }

        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        dataSource.apply(snapshot, animatingDifferences: true)
        return dataSource
    }

    private func updateCells(of header: ManageCollectionViewHeader) {
        var challenges: [Challenge]?

        switch header.section {
        case .participating:
            challenges = viewModel?.participatingChallenges.value
        case .created:
            challenges = viewModel?.createdChallenges.value
        case .ended:
            challenges = viewModel?.endedChallenges.value
        default:
            return
        }

        guard let items = challenges,
              let headerSection = header.section?.rawValue,
              let section = Section(rawValue: headerSection) else { return }

        guard var snapshot = dataSource?.snapshot(for: section) else { return }
        snapshot.deleteAll()
        if header.isExpanded {
            snapshot.append(items.map { Item.challenge($0) })
        }

        dataSource?.apply(snapshot, to: section)
    }

    private func expandHeaders() {
        let headers = collectionView.subviews.compactMap { $0 as? ManageCollectionViewHeader }
        for header in headers {
            header.isExpanded = true
            updateCells(of: header)
        }
    }

    @objc private func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
            guard let self = self else { return }
            self.expandHeaders()
            self.viewModel?.fetchMyChallenges()
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
}

extension ManageViewController: ChallengePromotionViewDelegate {
    func didTappedPromotionButton() {
        viewModel?.didTappedAddButton()
    }

    func didLoadedManageView() {
        viewModel?.fetchMyChallenges()
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
        guard let header = sender.view as? ManageCollectionViewHeader else { return }
        header.didTouchedHeader()
        updateCells(of: header)
    }
}
