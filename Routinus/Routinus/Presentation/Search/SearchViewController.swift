//
//  SearchViewController.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/02.
//

import Combine
import UIKit

class SearchViewController: UIViewController {
    enum Section: CaseIterable {
        case popularSearchTerm, challenge

        var title: String {
            switch self {
            case .popularSearchTerm:
                return "인기 검색어"
            case .challenge:
                return "챌린지 목록"
            }
        }
    }

    enum SearchContents: Hashable {
        case popularSearchTerm(String)
        case challenge(Challenge)
    }

    typealias DataSource = UICollectionViewDiffableDataSource<Section, SearchContents>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, SearchContents>

    private lazy var dataSource = configureDataSource()
    private lazy var snapshot = Snapshot()
    private var viewModel: SearchViewModelIO?
    private var cancellables = Set<AnyCancellable>()

    private var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .systemBackground

        collectionView.showsVerticalScrollIndicator = false

        collectionView.register(SearchCollectionViewHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SearchCollectionViewHeader.identifier)
        collectionView.register(SearchPopularTermCell.self,
                                forCellWithReuseIdentifier: SearchPopularTermCell.identifier)
        collectionView.register(SearchChallengeCell.self,
                                forCellWithReuseIdentifier: SearchChallengeCell.identifier)

        return collectionView
    }()
    init(with viewModel: SearchViewModelIO) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = dataSource
        self.snapshot.appendSections(Section.allCases)
        self.configureViews()
        self.viewTests()
    }

}

extension SearchViewController {
    private func configureDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: self.collectionView) { collectionView, indexPath, content in
            switch content {
            case .popularSearchTerm(let searchTerm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchPopularTermCell.identifier,
                                                              for: indexPath) as? SearchPopularTermCell
                cell?.configureViews(searchTerm: searchTerm)
                return cell

            case .challenge(let challenge):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchChallengeCell.identifier,
                                                              for: indexPath) as? SearchChallengeCell
                cell?.configureViews(challenge: challenge)
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
                        withReuseIdentifier: SearchCollectionViewHeader.identifier,
                        for: indexPath) as? SearchCollectionViewHeader
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]

            view?.title = section.title
            view?.configureViews()

            return view
        }
    }

    private func configureViews() {
        self.view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.view.addSubview(collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    static func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in
            let layout = SearchCollectionViewLayouts()
            return layout.section(at: sectionNumber)
        }
    }

    private func viewTests() {
        let popularTermItem = ["운동", "독서", "책읽기", "공부", "영어"]

        var popularSnapshot = self.dataSource.snapshot(for: Section.popularSearchTerm)
        let popularContents = popularTermItem.map { SearchContents.popularSearchTerm($0) }
        popularSnapshot.append(popularContents)
        self.dataSource.apply(popularSnapshot, to: Section.popularSearchTerm)
        
        let challengeItem = [Challenge(challengeID: "x", title: "30분 운동하기", introduction: "x", category: .exercise,
                                       imageURL: "", authExampleImageURL: "", thumbnailImageURL: "", authMethod: "",
                                       startDate: Date.toDate("2021110")!, endDate: Date.toDate("2021113")!, ownerID: "", week: 1, participantCount: 3),
                             Challenge(challengeID: "x", title: "30분 밥먹기", introduction: "x", category: .exercise,
                                                            imageURL: "", authExampleImageURL: "", thumbnailImageURL: "", authMethod: "",
                                                            startDate: Date.toDate("2021110")!, endDate: Date.toDate("2021113")!, ownerID: "", week: 1, participantCount: 3),
                             Challenge(challengeID: "x", title: "책읽기", introduction: "x", category: .exercise,
                                                            imageURL: "", authExampleImageURL: "", thumbnailImageURL: "", authMethod: "",
                                                            startDate: Date.toDate("2021110")!, endDate: Date.toDate("2021113")!, ownerID: "", week: 1, participantCount: 3),
                             Challenge(challengeID: "x", title: "독서하기", introduction: "x", category: .exercise,
                                                            imageURL: "", authExampleImageURL: "", thumbnailImageURL: "", authMethod: "",
                                                            startDate: Date.toDate("2021110")!, endDate: Date.toDate("2021113")!, ownerID: "", week: 1, participantCount: 3),
                             Challenge(challengeID: "x", title: "커밋하기", introduction: "x", category: .exercise,
                                                            imageURL: "", authExampleImageURL: "", thumbnailImageURL: "", authMethod: "",
                                                            startDate: Date.toDate("2021110")!, endDate: Date.toDate("2021113")!, ownerID: "", week: 1, participantCount: 3),
                             Challenge(challengeID: "x", title: "영어 공부하기", introduction: "x", category: .exercise,
                                                            imageURL: "", authExampleImageURL: "", thumbnailImageURL: "", authMethod: "",
                                                            startDate: Date.toDate("2021110")!, endDate: Date.toDate("2021113")!, ownerID: "", week: 1, participantCount: 3),
                             Challenge(challengeID: "x", title: "일본어 공부하기", introduction: "x", category: .exercise,
                                                            imageURL: "", authExampleImageURL: "", thumbnailImageURL: "", authMethod: "",
                                                            startDate: Date.toDate("2021110")!, endDate: Date.toDate("2021113")!, ownerID: "", week: 1, participantCount: 3),
                             Challenge(challengeID: "x", title: "약챙겨먹기", introduction: "x", category: .exercise,
                                                            imageURL: "", authExampleImageURL: "", thumbnailImageURL: "", authMethod: "",
                                                            startDate: Date.toDate("2021110")!, endDate: Date.toDate("2021113")!, ownerID: "", week: 1, participantCount: 3)]

        var challengeSnapshot = self.dataSource.snapshot(for: Section.challenge)
        let challengeContents = challengeItem.map { SearchContents.challenge($0) }
        challengeSnapshot.append(challengeContents)
        self.dataSource.apply(challengeSnapshot, to: Section.challenge)
    }
}

extension SearchViewController: UICollectionViewDelegate {
}
