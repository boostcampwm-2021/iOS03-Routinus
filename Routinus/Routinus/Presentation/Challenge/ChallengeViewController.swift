//
//  ChallengeViewController.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/02.
//

import UIKit
import SnapKit

class ChallengeViewController: UIViewController {
    enum Section: CaseIterable {
        case recommend, category

        var title: String {
            switch self {
            case .recommend:
                return "추천 챌린지"
            case .category:
                return "챌린지 카테고리"
            }
        }
    }

    enum ItemType {
        case recommend
        case category
    }

    struct Item: Hashable {
        let data: Any
        let type: ItemType
        private let identifier: UUID

        init(data: Any, type: ItemType) {
            self.data = data
            self.type = type
            self.identifier = UUID()
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(self.identifier)
        }

        static func == (lhs: ChallengeViewController.Item, rhs: ChallengeViewController.Item) -> Bool {
            lhs.identifier == rhs.identifier
        }
    }

    // MARK: - View Initialize
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

    // MARK: - Private Properties
    private lazy var dataSource = configureDataSource()
    private lazy var snapshot = Snapshot()

    private lazy var searchButton: UIButton = {
//        let button = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: nil)
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .black
        return button
    }()

    private var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .systemBackground

        collectionView.showsVerticalScrollIndicator = false

        collectionView.register(ChallengeCollectionViewHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: ChallengeCollectionViewHeader.identifier)
        collectionView.register(ChallengeRecommendCell.self,
                                forCellWithReuseIdentifier: ChallengeRecommendCell.identifier)
        collectionView.register(ChallengeCategoryCell.self,
                                forCellWithReuseIdentifier: ChallengeCategoryCell.identifier)

        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = dataSource

        self.snapshot.appendSections(Section.allCases)
        self.configureViews()
        self.bindViews()
    }

    private func configureDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: self.collectionView) { collectionView, indexPath, item in
            switch item.type {
            case .recommend:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChallengeRecommendCell.identifier,
                                                              for: indexPath) as? ChallengeRecommendCell
                if let data = item.data as? String { cell?.configureViews(data: data) }
                return cell

            case .category:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChallengeCategoryCell.identifier,
                                                              for: indexPath) as? ChallengeCategoryCell
                cell?.configureViews()
                return cell
            }
        }
        configureHeader(of: dataSource)
        return dataSource
    }

    private func configureHeader(of dataSource: DataSource) {
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }

            let view = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: ChallengeCollectionViewHeader.identifier,
                        for: indexPath) as? ChallengeCollectionViewHeader
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]

            view?.title = section.title
            view?.seeAllButton.addTarget(self, action: #selector(self.showWhatsNewViewController), for: .touchUpInside)


            switch section {
            case .category:
                view?.addSeeAllButton()
            default:
                view?.removeStackSubviews()
            }
            return view
        }
    }

    private func applySnapshot(data: [Item], section: Section, animatingDifferences: Bool = true) {
        self.snapshot.appendItems(data, toSection: section)
        self.dataSource.apply(self.snapshot)
    }

    @objc
    private func showWhatsNewViewController(_ sender: UIButton) {
//        let whatsNewViewController = WhatsNewViewContoller()
//        if sender == self.headerView.whatsNewButton {
//            whatsNewViewController.viewModel.paging = 0
//            whatsNewViewController.viewModel.fetchAllNews()
//        } else {
//            whatsNewViewController.viewModel.fetchEventNews()
//        }
//        self.navigationController?.pushViewController(whatsNewViewController, animated: true)
    }
}

extension ChallengeViewController: UICollectionViewDelegate {
    private func configureViews() {
        self.view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Challenges"
        self.navigationController?.navigationBar.addSubview(searchButton)
        searchButton.frame = CGRect(x: self.view.frame.width, y: 0, width: 40, height: 40)

        searchButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        }
        self.view.addSubview(collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    static func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in
            let layout = CollectionViewLayouts()
            return layout.section(at: sectionNumber)
        }
    }

    func bindViews() {
        let recommendItem = [Item.init(data: "수채화로 컬러링하기", type: .recommend),
                             Item.init(data: "물 e리터 마시기", type: .recommend)]
        self.applySnapshot(data: recommendItem, section: .recommend)

        let mainItem = Item.init(data: "category", type: .category)
        self.applySnapshot(data: [mainItem], section: .category)

        // TODO: - 바인딩 부분 수정하기
//        self.viewModel.$events.receive(on: RunLoop.main).sink { [weak self] events in
//            guard let self = self else { return }
//
//           events.forEach {
//               let data = Item.init(data: $0, type: .events)
//               self.applySnapshot(data: data, section: .events)
//           }
//        }.store(in: &cancellables)
//
//        self.viewModel.$mainEvent.receive(on: RunLoop.main).sink { [weak self] event in
//            guard let self = self, let event = event else { return }
//            let mainItem = Item.init(data: event, type: .mainEvent)
//
//            self.applySnapshot(data: mainItem, section: .mainEvent)
//        }.store(in: &cancellables)
    }
}
