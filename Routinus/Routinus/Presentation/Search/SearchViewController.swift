//
//  SearchViewController.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/02.
//

import Combine
import UIKit

final class SearchViewController: UIViewController {
    enum Section: CaseIterable {
        case popularSearchKeyword, challenge

        var title: String {
            switch self {
            case .popularSearchKeyword:
                return "popular keyword".localized
            case .challenge:
                return "challenge list".localized
            }
        }
    }

    enum SearchContents: Hashable {
        case popularSearchKeyword(String)
        case challenge(Challenge)
    }

    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, SearchContents>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, SearchContents>

    private lazy var searchBarView = SearchBarContainerView()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: SearchViewController.createLayout()
        )
        collectionView.backgroundColor = UIColor(named: "SystemBackground")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(
            SearchCollectionViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SearchCollectionViewHeader.identifier
        )
        collectionView.register(
            SearchPopularKeywordCollectionViewCell.self,
            forCellWithReuseIdentifier: SearchPopularKeywordCollectionViewCell.identifier
        )
        collectionView.register(
            ChallengeCollectionViewCell.self,
            forCellWithReuseIdentifier: ChallengeCollectionViewCell.identifier
        )
        return collectionView
    }()

    private var dataSource: DataSource?
    private var snapshot = Snapshot()
    private var viewModel: SearchViewModelIO?
    private var cancellables = Set<AnyCancellable>()

    init(with viewModel: SearchViewModelIO) {
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

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBarView.hideKeyboard()
        collectionView.removeAfterimage()
    }

    static func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in
            let layout = SearchCollectionViewLayouts()
            return layout.section(at: sectionNumber)
        }
    }
}

extension SearchViewController {
    private func configure() {
        configureViews()
        configureViewModel()
        configureDelegates()
        configureDataSource()
        configureSnapshot()
        configureRefreshControl()
    }

    private func configureViews() {
        view.backgroundColor = UIColor(named: "SystemBackground")
        view.addSubview(collectionView)
        configureNavigationBar()
        configureKeyboard()
        collectionView.anchor(horizontal: collectionView.superview,
                              vertical: collectionView.superview)
    }

    private func configureViewModel() {
        viewModel?.popularKeywords
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] keywords in
                guard let self = self,
                      let dataSource = self.dataSource else { return }
                var popularSnapshot = dataSource.snapshot(for: Section.popularSearchKeyword)
                let popularContents = keywords.map { SearchContents.popularSearchKeyword($0) }
                popularSnapshot.append(popularContents)
                dataSource.apply(popularSnapshot, to: Section.popularSearchKeyword)
            })
            .store(in: &cancellables)

        viewModel?.challenges
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] challengeItem in
                guard let self = self,
                      let dataSource = self.dataSource else { return }
                var challengeSnapshot = dataSource.snapshot(for: Section.challenge)
                let challengeContents = challengeItem.map { SearchContents.challenge($0) }
                challengeSnapshot.deleteAll()
                challengeSnapshot.append(challengeContents)
                dataSource.apply(challengeSnapshot,
                                      to: Section.challenge,
                                      animatingDifferences: true)
            })
            .store(in: &cancellables)
    }

    private func configureDelegates() {
        searchBarView.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = dataSource
    }

    private func configureDataSource() {
        dataSource = DataSource(
            collectionView: collectionView
        ) { [weak self] collectionView, indexPath, content in
            guard let self = self else { return nil }
            switch content {
            case .popularSearchKeyword(let keyword):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: SearchPopularKeywordCollectionViewCell.identifier,
                    for: indexPath
                ) as? SearchPopularKeywordCollectionViewCell
                cell?.updateKeyword(keyword)
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
        configureHeader(of: dataSource)
    }

    private func configureSnapshot() {
        snapshot.appendSections(Section.allCases)
    }

    private func configureRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(
            string: "swipe".localized,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "DayColor") as Any,
                         NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]
        )
        self.collectionView.refreshControl = refreshControl
    }

    private func configureHeader(of dataSource: DataSource?) {
        guard let dataSource = dataSource else { return }

        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else { return nil }
            let view = collectionView.dequeueReusableSupplementaryView(
                        ofKind: kind,
                        withReuseIdentifier: SearchCollectionViewHeader.identifier,
                        for: indexPath
            ) as? SearchCollectionViewHeader
            let section = dataSource.snapshot().sectionIdentifiers[indexPath.section]
            view?.updateTitle(section.title)
            return view
        }
    }

    private func configureNavigationBar() {
        searchBarView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
        navigationItem.titleView = searchBarView
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.largeTitleDisplayMode = .never
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = UIColor(named: "SystemForeground")
        navigationItem.backBarButtonItem = backBarButtonItem
    }

    private func configureKeyboard() {
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                action: #selector(tappedView))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        collectionView.addGestureRecognizer(singleTapGestureRecognizer)
    }

    @objc private func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.viewModel?.fetchChallenges()
            self.searchBarView.updateSearchBar(keyword: "")
            self.collectionView.refreshControl?.endRefreshing()
        }
    }

    @objc private func tappedView(sender: UITapGestureRecognizer) {
        searchBarView.hideKeyboard()
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.didChangedSearchText(searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBarView.hideKeyboard()
    }
}

extension SearchViewController: SearchPopularKeywordDelegate {
    func didTappedKeywordButton(keyword: String?) {
        guard let keyword = keyword else { return }
        self.searchBarView.updateSearchBar(keyword: keyword)
        self.viewModel?.didChangedSearchText(keyword)
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            viewModel?.didTappedChallenge(index: indexPath.item)
        }
    }
}
