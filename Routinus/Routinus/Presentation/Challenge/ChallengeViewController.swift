//
//  ChallengeViewController.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/02.
//

import Combine
import UIKit

import SnapKit

class ChallengeViewController: UIViewController {
    enum Section: CaseIterable {
        case recommend, category

        var title: String {
            switch self {
            case .recommend:
                return ""
            case .category:
                return "챌린지 카테고리"
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
    private lazy var snapshot = Snapshot()
    private var viewModel: ChallengeViewModelIO?
    private var cancellables = Set<AnyCancellable>()

    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTappedSearchButton), for: .touchUpInside)
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
    
    init(with viewModel: ChallengeViewModelIO) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
        self.configureViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchButton.isHidden = false
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.searchButton.isHidden = true
    }
}

extension ChallengeViewController {
    private func configureDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: self.collectionView) { collectionView, indexPath, content in
            switch content {
            case .recommend(let recommendChallenge):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChallengeRecommendCell.identifier,
                                                              for: indexPath) as? ChallengeRecommendCell
                cell?.configureViews(recommendChallenge: recommendChallenge)
                return cell

            case .category:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChallengeCategoryCell.identifier,
                                                              for: indexPath) as? ChallengeCategoryCell
                cell?.delegate = self
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
            view?.seeAllButton.addTarget(self, action: #selector(self.didTappedSearchButton), for: .touchUpInside)

            switch section {
            case .category:
                view?.addSeeAllButton()
            default:
                view?.removeStackSubviews()
            }
            return view
        }
    }

    private func configureViews() {
        self.view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Challenges"
        self.configureSearchButton()
        self.view.addSubview(collectionView)
        self.collectionView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    private func configureSearchButton() {
        self.navigationController?.navigationBar.addSubview(searchButton)
        self.searchButton.frame = CGRect(x: self.view.frame.width, y: 0, width: 40, height: 40)

        self.searchButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.lastBaseline.equalToSuperview().offset(-16)
        }
    }

    private func configureViewModel() {
        self.viewModel?.recommendChallenge
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] recommendChallenge in
                guard let self = self else { return }
                var snapshot = self.dataSource.snapshot(for: Section.recommend)
                let contents = recommendChallenge.map { ChallengeContents.recommend($0) }
                snapshot.append(contents)
                self.dataSource.apply(snapshot, to: Section.recommend)
                self.applyCategory()
            })
            .store(in: &cancellables)
    }

    private func applyCategory() {
        var snapshot = self.dataSource.snapshot(for: Section.category)
        snapshot.append([ChallengeContents.category])
        self.dataSource.apply(snapshot, to: Section.category)
    }

    static func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in
            let layout = CollectionViewLayouts()
            return layout.section(at: sectionNumber)
        }
    }
}

extension ChallengeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.viewModel?.didTappedRecommendChallenge(index: indexPath.item)
        }
    }
}

extension ChallengeViewController: ChallengeCategoryCellDelegate {
    func didTappedCategoryButton(category: Category) {
        self.viewModel?.didTappedCategoryButton(category: category)
    }
}

extension ChallengeViewController {
    @objc private func didTappedSearchButton(_ sender: UIButton) {
        self.viewModel?.didTappedSearchButton()
    }
}
