//
//  HomeViewController.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/01.
//

import Combine
import UIKit

final class HomeViewController: UIViewController {
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, TodayRoutine>
    typealias DataSource = UITableViewDiffableDataSource<Int, TodayRoutine>

    private lazy var scrollView: UIScrollView = UIScrollView()
    private lazy var contentView: UIView = UIView()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width <= 350 ? 30 : 34,
                                       weight: .bold)
        return label
    }()
    private lazy var launchView = LaunchView(frame: CGRect(x: 0,
                                                           y: 0,
                                                           width: view.frame.width,
                                                           height: view.frame.height))
    private lazy var continuityView = HomeContinuityView()
    private lazy var todayRoutineView = HomeTodayRoutineView()
    private lazy var calendarView = HomeCalendarView(viewModel: viewModel)

    private var dataSource: DataSource?
    private var viewModel: HomeViewModelIO?
    private var cancellables = Set<AnyCancellable>()

    init(with viewModel: HomeViewModelIO) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
        scrollView.removeAfterimage()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

extension HomeViewController {
    private func configure() {
        configureLaunchView()
        configureThemeStyle()
        configureViews()
        configureViewModel()
        configureDelegates()
        configureDataSource()
        configureRefreshControl()
    }

    private func configureLaunchView() {
        tabBarController?.view.addSubview(launchView)
    }

    private func configureThemeStyle() {
        guard let rawValue = viewModel?.themeStyle(),
              let style = UIUserInterfaceStyle(rawValue: rawValue) else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.4) {
                self.view.window?.overrideUserInterfaceStyle = style
            }
        }
    }

    private func configureViews() {
        let smallWidth = UIScreen.main.bounds.width <= 350
        let offset = smallWidth ? 15.0 : 20.0

        view.backgroundColor = UIColor(named: "SystemBackground")

        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = UIColor(named: "SystemForeground")
        navigationItem.backBarButtonItem = backBarButtonItem

        view.addSubview(scrollView)
        scrollView.anchor(edges: view.safeAreaLayoutGuide)

        scrollView.addSubview(contentView)
        contentView.anchor(centerX: contentView.superview?.centerXAnchor,
                           vertical: contentView.superview,
                           width: UIScreen.main.bounds.width)

        contentView.addSubview(titleLabel)
        titleLabel.anchor(horizontal: titleLabel.superview,
                          paddingHorizontal: offset,
                          top: titleLabel.superview?.topAnchor,
                          paddingTop: smallWidth ? 28 : 32,
                          height: 80)

        contentView.addSubview(continuityView)
        continuityView.anchor(horizontal: continuityView.superview,
                              paddingHorizontal: offset,
                              top: titleLabel.bottomAnchor,
                              paddingTop: 10,
                              height: 80)

        contentView.addSubview(todayRoutineView)
        todayRoutineView.anchor(horizontal: todayRoutineView.superview,
                                top: continuityView.bottomAnchor,
                                paddingTop: 25)

        let constraint = todayRoutineView.heightAnchor.constraint(equalToConstant: 25)
        constraint.priority = UILayoutPriority(900)
        constraint.isActive = true

        contentView.addSubview(calendarView)
        calendarView.anchor(centerX: calendarView.superview?.centerXAnchor,
                            top: todayRoutineView.bottomAnchor,
                            paddingTop: offset,
                            width: UIScreen.main.bounds.width - offset,
                            height: 500)
        contentView.anchor(bottom: calendarView.bottomAnchor)
    }

    private func configureViewModel() {
        viewModel?.user
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] user in
                guard let self = self else { return }
                self.titleLabel.text = "%@ routine".localized(with: user.name)
                self.continuityView.updateContents(with: user)
            })
            .store(in: &cancellables)

        viewModel?.todayRoutines
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] routines in
                guard let self = self,
                      let dataSource = self.dataSource else { return }
                var snapshot = Snapshot()
                snapshot.deleteAllItems()
                dataSource.apply(snapshot, animatingDifferences: false)
                snapshot.appendSections([0])
                snapshot.appendItems(routines)
                dataSource.apply(snapshot, animatingDifferences: false)
                self.todayRoutineView.updateTableViewConstraints(cellCount: routines.count)
            })
            .store(in: &cancellables)

        viewModel?.days
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] _ in
                guard let self = self else { return }
                self.calendarView.reloadData()
            })
            .store(in: &cancellables)
    }

    private func configureDelegates() {
        todayRoutineView.delegate = self
        todayRoutineView.dataSource = dataSource
        todayRoutineView.promotionViewDelegate = self
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.explanationDeleatge = self
    }

    private func configureDataSource() {
        dataSource = DataSource(
            tableView: todayRoutineView.tableView
        ) { [weak self] tableView, indexPath, _ in
            guard let self = self,
                  let cell = tableView.dequeueReusableCell(
                    withIdentifier: HomeRoutineTableViewCell.identifier,
                    for: indexPath
                  ) as? HomeRoutineTableViewCell,
                  let routines = self.viewModel?.todayRoutines.value else { return UITableViewCell() }
            cell.updateCell(routine: routines[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }
    }

    private func configureRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(
            string: "swipe".localized,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "DayColor"),
                         NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]
        )
        scrollView.refreshControl = refreshControl
    }

    @objc private func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
            guard let self = self else { return }
            self.viewModel?.fetchMyHomeData()
            self.scrollView.refreshControl?.endRefreshing()
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        guard let viewModel = viewModel else { return nil }
        var auth = UIContextualAction()
        if viewModel.participationAuthStates[indexPath.item] == .authenticated {
            auth = UIContextualAction(style: .normal,
                                      title: nil,
                                      handler: { (_, _, completion: @escaping (Bool) -> Void) in
                completion(true)
            })
            auth.backgroundColor = UIColor(named: "LightGray")
            auth.title = "certified".localized
        } else {
            auth = UIContextualAction(
                style: .normal,
                title: nil
            ) { [weak self] (_, _, completion: @escaping (Bool) -> Void) in
                guard let self = self else { return }
                self.viewModel?.didTappedTodayRoutineAuth(index: indexPath.row)
                completion(true)
            }
            auth.backgroundColor = UIColor(named: "MainColor")
            auth.title = "certify".localized
        }

        return UISwipeActionsConfiguration(actions: [auth])
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.didTappedTodayRoutine(index: indexPath.row)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        viewModel?.days.value.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let day = viewModel?.days.value[indexPath.row]

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HomeDateCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? HomeDateCollectionViewCell else { return UICollectionViewCell() }
        cell.updateDay(day)
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = CGFloat(collectionView.frame.width / 7) - 0.5
        let height = 55.0
        return CGSize(width: width, height: height)
    }
}

extension HomeViewController: ChallengePromotionViewDelegate {
    func didTappedPromotionButton() {
        viewModel?.didTappedAddChallengeButton()
    }
}

extension HomeViewController: ExplanationButtonDelegate {
    func didTappedExplanationButton() {
        viewModel?.didTappedExplanationButton()
    }
}
