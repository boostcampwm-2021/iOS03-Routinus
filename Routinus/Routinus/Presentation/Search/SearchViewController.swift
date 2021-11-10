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
    
    lazy var backButtonImage: UIImage? = {
        let image = UIImage(systemName: "chevron.backward")?
            .withAlignmentRectInsets(UIEdgeInsets(top: 0.0, left: -12.0, bottom: -5.0, right: 0.0))
        return image
    }()

    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()

    private var backButtonAppearance: UIBarButtonItemAppearance {
        let backButtonAppearance = UIBarButtonItemAppearance()
        backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear,
                                                           .font: UIFont.systemFont(ofSize: 0.0)]

        return backButtonAppearance
    }

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
        self.searchBar.delegate = self
        self.snapshot.appendSections(Section.allCases)
        self.configureViews()
        self.configureViewModel()
        self.setNavigationBarAppearance()
    }

}

extension SearchViewController {
    private func configureDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: self.collectionView) { collectionView, indexPath, content in
            switch content {
            case .popularSearchTerm(let searchTerm):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchPopularTermCell.identifier,
                                                              for: indexPath) as? SearchPopularTermCell
                cell?.configureViews(term: searchTerm)
                cell?.delegate = self
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
        self.view.addSubview(collectionView)
        self.setNavigationBarAppearance()
        self.keyboardConfigure()
        self.collectionView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    private func configureViewModel() {
        guard let popularTermItem = viewModel?.popularKeywords else { return }

        var popularSnapshot = self.dataSource.snapshot(for: Section.popularSearchTerm)
        let popularContents = popularTermItem.map { SearchContents.popularSearchTerm($0) }
        popularSnapshot.append(popularContents)
        self.dataSource.apply(popularSnapshot, to: Section.popularSearchTerm)

        self.viewModel?.challenges
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] challengeItem in
                guard let self = self else { return }
                var challengeSnapshot = self.dataSource.snapshot(for: Section.challenge)
                let challengeContents = challengeItem.map { SearchContents.challenge($0) }
                challengeSnapshot.append(challengeContents)
                self.dataSource.apply(challengeSnapshot, to: Section.challenge)
            })
            .store(in: &cancellables)
    }

    private func setNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemBackground
        appearance.setBackIndicatorImage(backButtonImage, transitionMaskImage: backButtonImage)
        appearance.backButtonAppearance = backButtonAppearance

        self.navigationItem.titleView = searchBar
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.compactAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = .black
    }

    static func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in
            let layout = SearchCollectionViewLayouts()
            return layout.section(at: sectionNumber)
        }
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            print(indexPath.item)
            self.viewModel?.didTappedChallenge(index: indexPath.item)
        }
    }
}

extension SearchViewController: SearchPopularTermDelegate {
    func didTappedSearchTermButton(term: String?) {
        guard let term = term else { return }
        print(term)
        self.searchBar.text = term
        self.viewModel?.didTappedSearchButton(keyword: term)
        performQuery(with: term)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // MARK: - TODO viewModel searchText 전달
        print(searchText)
//        viewModel?.didTappedSearchButton(keyword: searchText)
        performQuery(with: searchText)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("start")
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
}

extension SearchViewController {
    private func keyboardConfigure() {
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedView))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        self.collectionView.addGestureRecognizer(singleTapGestureRecognizer)
    }

    @objc func tappedView(sender: UITapGestureRecognizer) {
        self.searchBar.endEditing(true)
    }

    func performQuery(with filter: String?) {
        self.viewModel?.challenges
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] challengeItem in
                guard let self = self else { return }
                var challengeSnapshot = self.dataSource.snapshot(for: Section.challenge)
                var challengeContents = challengeItem.map { SearchContents.challenge($0) }
                if filter != "" {
                     challengeContents = challengeItem.filter {
                        $0.title.contains(filter ?? "")
                    }.map { SearchContents.challenge($0) }
                }
                challengeSnapshot.deleteAll()
                challengeSnapshot.append(challengeContents)
                self.dataSource.apply(challengeSnapshot, to: Section.challenge, animatingDifferences: true)
            })
            .store(in: &cancellables)
    }
}
