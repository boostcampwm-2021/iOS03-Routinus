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

    typealias DataSource = UICollectionViewDiffableDataSource<Section, SearchContents>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, SearchContents>

    private lazy var searchBarView = SearchBarContainerView()
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
        collectionView.register(SearchPopularKeywordCollectionViewCell.self,
                                forCellWithReuseIdentifier: SearchPopularKeywordCollectionViewCell.identifier)
        collectionView.register(ChallengeCollectionViewCell.self,
                                forCellWithReuseIdentifier: ChallengeCollectionViewCell.identifier)

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
        self.searchBarView.delegate = self
        self.snapshot.appendSections(Section.allCases)
        self.configureViews()
        self.configureViewModel()
        self.configureRefreshControl()
        self.didLoadedSearchView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.searchBarView.hideKeyboard()
    }
}

extension SearchViewController {
    private func configureDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: self.collectionView) { collectionView, indexPath, content in
            switch content {
            case .popularSearchKeyword(let keyword):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchPopularKeywordCollectionViewCell.identifier,
                                                              for: indexPath) as? SearchPopularKeywordCollectionViewCell
                cell?.configureViews(keyword: keyword)
                cell?.delegate = self
                return cell

            case .challenge(let challenge):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChallengeCollectionViewCell.identifier,
                                                              for: indexPath) as? ChallengeCollectionViewCell
                cell?.setTitle(challenge.title)
                self.viewModel?.imageData(from: challenge.challengeID,
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
        self.configureNavigationBar()
        self.configureKeyboard()
        collectionView.anchor(horizontal: collectionView.superview,
                              vertical: collectionView.superview)
    }

    private func configureViewModel() {
        self.viewModel?.popularKeywords
            .receive(on: RunLoop.main)
            .sink(receiveValue: { keywords in
                var popularSnapshot = self.dataSource.snapshot(for: Section.popularSearchKeyword)
                let popularContents = keywords.map { SearchContents.popularSearchKeyword($0) }
                popularSnapshot.append(popularContents)
                self.dataSource.apply(popularSnapshot, to: Section.popularSearchKeyword)
            })
            .store(in: &cancellables)

        self.viewModel?.challenges
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] challengeItem in
                guard let self = self else { return }
                var challengeSnapshot = self.dataSource.snapshot(for: Section.challenge)
                let challengeContents = challengeItem.map { SearchContents.challenge($0) }
                challengeSnapshot.deleteAll()
                challengeSnapshot.append(challengeContents)
                self.dataSource.apply(challengeSnapshot, to: Section.challenge, animatingDifferences: true)
            })
            .store(in: &cancellables)
    }

    private func configureNavigationBar() {
        self.searchBarView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
        self.navigationItem.titleView = searchBarView
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.largeTitleDisplayMode = .never
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = UIColor(named: "Black")
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }

    static func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in
            let layout = SearchCollectionViewLayouts()
            return layout.section(at: sectionNumber)
        }
    }

    private func configureRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                           action: #selector(refresh),
                           for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "swipe".localized,
                                                     attributes: [NSAttributedString.Key.foregroundColor:
                                                                    UIColor.systemGray,
                                                                  NSAttributedString.Key.font:
                                                                    UIFont.boldSystemFont(ofSize: 20)])
        self.collectionView.refreshControl = refreshControl
    }

    @objc private func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.viewModel?.didLoadedSearchView()
            self.searchBarView.updateSearchBar(keyword: "")
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
}

extension SearchViewController {
    private func configureKeyboard() {
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedView))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        self.collectionView.addGestureRecognizer(singleTapGestureRecognizer)
    }

    @objc func tappedView(sender: UITapGestureRecognizer) {
        self.searchBarView.hideKeyboard()
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            self.viewModel?.didTappedChallenge(index: indexPath.item)
        }
    }
}

extension SearchViewController: SearchPopularKeywordDelegate {
    func didTappedKeywordButton(keyword: String?) {
        guard let keyword = keyword else { return }
        self.searchBarView.updateSearchBar(keyword: keyword)
        self.viewModel?.didChangedSearchText(keyword)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.viewModel?.didChangedSearchText(searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBarView.hideKeyboard()
    }

    func didLoadedSearchView() {
        self.viewModel?.didLoadedSearchView()
    }
}
