//
//  ChallengeViewController.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/02.
//

import Combine
import UIKit

final class ChallengeViewController: UIViewController {
    enum Section: CaseIterable {
        case recommend, category

        var title: String {
            switch self {
            case .recommend:
                return "challenge".localized
            case .category:
                return "challenge category".localized
            }
        }
    }

    enum ChallengeContents: Hashable {
        case recommend(Challenge)
        case category
    }

    typealias DataSource = UICollectionViewDiffableDataSource<Section, ChallengeContents>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ChallengeContents>

    private lazy var dataSource = configureDataSource()
    private var viewModel: ChallengeViewModelIO?
    private var cancellables = Set<AnyCancellable>()

    private var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .systemBackground

        collectionView.showsVerticalScrollIndicator = false

        collectionView.register(
            ChallengeRecommendCollectionViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ChallengeRecommendCollectionViewHeader.identifier
        )
        collectionView.register(
            ChallengeCategoryCollectionViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ChallengeCategoryCollectionViewHeader.identifier
        )
        collectionView.register(
            ChallengeRecommendCollectionViewCell.self,
            forCellWithReuseIdentifier: ChallengeRecommendCollectionViewCell.identifier
        )
        collectionView.register(
            ChallengeCategoryCollectionViewCell.self,
            forCellWithReuseIdentifier: ChallengeCategoryCollectionViewCell.identifier
        )

        return collectionView
    }()

    init(with viewModel: ChallengeViewModelIO) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        configureViews()
        configureViewModel()
        configureCategory()
        configureRefreshControl()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        collectionView.removeAfterimage()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

extension ChallengeViewController {
    private func configureDataSource() -> DataSource? {
        let dataSource = DataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, content in
            guard let self = self else { return nil }
            switch content {
            case .recommend(let recommendChallenge):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ChallengeRecommendCollectionViewCell.identifier,
                    for: indexPath
                ) as? ChallengeRecommendCollectionViewCell
                cell?.configureViews(recommendChallenge: recommendChallenge)
                return cell
            case .category:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ChallengeCategoryCollectionViewCell.identifier,
                    for: indexPath
                ) as? ChallengeCategoryCollectionViewCell
                cell?.delegate = self
                cell?.configureViews()
                return cell
            }
        }

        configureHeader(of: dataSource)
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        dataSource.apply(snapshot, animatingDifferences: true)
        return dataSource
    }

    private func configureHeader(of dataSource: DataSource) {
        dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self = self else { return nil }
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
            let section = Section.allCases[indexPath.section]

            switch section {
            case .recommend:
                let recommendHeader = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: ChallengeRecommendCollectionViewHeader.identifier,
                    for: indexPath
                ) as? ChallengeRecommendCollectionViewHeader

                recommendHeader?.delegate = self
                recommendHeader?.title = section.title
                recommendHeader?.addSearchButton()
                return recommendHeader
            case .category:
                let categoryHeader = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: ChallengeCategoryCollectionViewHeader.identifier,
                    for: indexPath
                ) as? ChallengeCategoryCollectionViewHeader

                categoryHeader?.delegate = self
                categoryHeader?.title = section.title
                categoryHeader?.addSeeAllButton()
                return categoryHeader
            }
        }
    }

    private func configureViews() {
        view.backgroundColor = .systemBackground
        configureNavigationBar()

        view.addSubview(collectionView)
        let smallWidth = UIScreen.main.bounds.width <= 350
        let offset = smallWidth ? 28.0 : 32.0
        collectionView.anchor(edges: view.safeAreaLayoutGuide)
        collectionView.contentInset = .init(top: offset, left: 0, bottom: 0, right: 0)
    }

    private func configureNavigationBar() {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = UIColor(named: "Black")
        navigationItem.backBarButtonItem = backBarButtonItem
    }

    private func configureViewModel() {
        viewModel?.recommendChallenges
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] recommendChallenges in
                guard let self = self, let dataSource = self.dataSource else { return }
                var snapshot = dataSource.snapshot(for: Section.recommend)
                let contents = recommendChallenges.map { ChallengeContents.recommend($0) }
                snapshot.deleteAll()
                snapshot.append(contents)
                dataSource.apply(snapshot, to: Section.recommend)
            })
            .store(in: &cancellables)
    }

    private func configureCategory() {
        guard let dataSource = dataSource else { return }
        var snapshot = dataSource.snapshot(for: Section.category)
        snapshot.append([ChallengeContents.category])
        dataSource.apply(snapshot, to: Section.category)
    }

    static func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in
            let layout = ChallengeCollectionViewLayouts()
            return layout.section(at: sectionNumber)
        }
    }

    private func configureRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(refresh),
                                 for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(
            string: "swipe".localized,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray,
                         NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        )
        collectionView.refreshControl = refreshControl
    }

    @objc private func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
            guard let self = self else { return }
            self.viewModel?.fetchChallenge()
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
}

extension ChallengeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            viewModel?.didTappedRecommendChallenge(index: indexPath.item)
        }
    }
}

extension ChallengeViewController: ChallengeRecommendHeaderDelegate {
    func didTappedSearchButton() {
        viewModel?.didTappedSearchButton()
    }
}

extension ChallengeViewController: ChallengeCategoryHeaderDelegate {
    func didTappedSeeAllButton() {
        viewModel?.didTappedSeeAllButton()
    }
}

extension ChallengeViewController: ChallengeCategoryCellDelegate {
    func didTappedCategoryButton(category: Challenge.Category) {
        viewModel?.didTappedCategoryButton(category: category)
    }
}

extension ChallengeViewController {
    @objc private func didTappedSearchButton(_ sender: UIButton) {
        viewModel?.didTappedSearchButton()
    }
}
