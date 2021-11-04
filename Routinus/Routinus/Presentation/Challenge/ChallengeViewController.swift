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
        case recommend, main

        var title: String {
            switch self {
            case .recommend:
                return ""
            case .main:
                return "챌린지 카테고리"
            }
        }
    }

    enum ItemType {
        case recommend
        case main
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

    private var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .white

        collectionView.showsVerticalScrollIndicator = false

        collectionView.register(ChallengeCollectionViewHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: ChallengeCollectionViewHeader.identifier)
        collectionView.register(ChallengeRecommendCell.self,
                                forCellWithReuseIdentifier: ChallengeRecommendCell.identifier)
        collectionView.register(ChallengeMainCell.self,
                                forCellWithReuseIdentifier: ChallengeMainCell.identifier)

        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = configureDataSource()

        self.snapshot.appendSections(Section.allCases)
        configureViews()
        bindViews()
    }

    private func configureDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: self.collectionView) { collectionView, indexPath, item in
            switch item.type {
            case .recommend:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChallengeRecommendCell.identifier,
                                                              for: indexPath) as? ChallengeRecommendCell
                if let data = item.data as? String { cell?.configureViews(data: data) }
                return cell

            case .main:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChallengeMainCell.identifier,
                                                              for: indexPath) as? ChallengeMainCell
                if let data = item.data as? String { cell?.configureViews() }
                return cell

            }
        }
        configureHeader(of: dataSource)
        return dataSource
    }

    private func configureHeader(of dataSource: DataSource) {
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                            withReuseIdentifier: ChallengeCollectionViewHeader.identifier,
                                                            for: indexPath) as? ChallengeCollectionViewHeader

            view?.title = section.title
            view?.seeAllButton.addTarget(self, action: #selector(self.showWhatsNewViewController), for: .touchUpInside)
            view?.removeStackSubviews()

            switch section {
            case .main:
                view?.addSeeAllButton()
            default:
                break
            }
            return view
        }
    }

    private func applySnapshot(data: Item, section: Section, animatingDifferences: Bool = true) {
        self.snapshot.appendItems([data], toSection: section)
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
        self.view.backgroundColor = .white

        self.view.addSubview(collectionView)    // 그림자 표시 하려고 collectionView 먼저
        self.collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalTo(0)
            make.bottom.equalToSuperview().offset(-84)
        }
    }

    static func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in
            let layout = collectionViewLayouts()
            return layout.section(at: sectionNumber)
        }
    }

    func bindViews() {
        let recommendItem = Item.init(data: "title1", type: .recommend)
        self.applySnapshot(data: recommendItem, section: .recommend)

        let mainItem = Item.init(data: "main", type: .main)
        self.applySnapshot(data: mainItem, section: .main)
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
