//
//  HomeViewController.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/01.
//

import Combine
import UIKit

final class HomeViewController: UIViewController {
    typealias DataSource = UITableViewDiffableDataSource<Int, TodayRoutine>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, TodayRoutine>

    private lazy var scrollView: UIScrollView = UIScrollView()
    private lazy var contentView: UIView = UIView()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width <= 350 ? 30 : 34,
                                       weight: .bold)
        return label
    }()
    private lazy var continuityView = ContinuityView()
    private lazy var todayRoutineView = TodayRoutineView()
    private lazy var calendarView = CalendarView(viewModel: viewModel)
    private lazy var dataSource = configureDataSource()

    private var viewModel: HomeViewModelIO?
    private var cancellables = Set<AnyCancellable>()
    private var achievements = [Achievement]()

    init(with viewModel: HomeViewModelIO) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        configureViewModel()
        configureDelegates()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        calendarView.reloadData()
    }
}

extension HomeViewController {
    private func configureViews() {
        let smallWidth = UIScreen.main.bounds.width <= 350
        let offset = smallWidth ? 15.0 : 20.0

        self.view.backgroundColor = .white
        self.configureNavigationBar()

        self.view.addSubview(scrollView)
        scrollView.anchor(edges: self.view.safeAreaLayoutGuide)

        self.scrollView.addSubview(contentView)
        contentView.anchor(centerX: contentView.superview?.centerXAnchor,
                           vertical: contentView.superview,
                           width: UIScreen.main.bounds.width)

        self.contentView.addSubview(titleLabel)
        titleLabel.anchor(horizontal: titleLabel.superview, paddingHorizontal: offset,
                          top: titleLabel.superview?.topAnchor, paddingTop: smallWidth ? 28 : 32,
                          height: 80)

        self.contentView.addSubview(continuityView)
        continuityView.anchor(horizontal: continuityView.superview, paddingHorizontal: offset,
                              top: titleLabel.bottomAnchor, paddingTop: 10,
                              height: 80)

        self.contentView.addSubview(todayRoutineView)
        todayRoutineView.anchor(horizontal: todayRoutineView.superview,
                                top: self.continuityView.bottomAnchor, paddingTop: 25)
        let constraint = todayRoutineView.heightAnchor.constraint(equalToConstant: 25)
        constraint.priority = UILayoutPriority(900)
        constraint.isActive = true

        self.contentView.addSubview(calendarView)
        calendarView.anchor(centerX: calendarView.superview?.centerXAnchor,
                            top: todayRoutineView.bottomAnchor, paddingTop: offset,
                            width: UIScreen.main.bounds.width - offset,
                            height: 450)
        contentView.anchor(bottom: calendarView.bottomAnchor)
    }

    private func configureNavigationBar() {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }

    private func configureViewModel() {
        self.viewModel?.user
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] user in
                guard let self = self else { return }
                self.titleLabel.text = user.name + "님의 Routine"
                self.continuityView.configureContents(with: user)
            })
            .store(in: &cancellables)

        self.viewModel?.todayRoutines
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] routines in
                guard let self = self else { return }
                var snapshot = Snapshot()
                snapshot.appendSections([0])
                snapshot.appendItems(routines)
                self.dataSource.apply(snapshot)
                self.todayRoutineView.updateTableViewConstraints(cellCount: routines.count)
            })
            .store(in: &cancellables)

        self.viewModel?.days
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
        todayRoutineView.challengeAddDelegate = self

        calendarView.delegate = self
        calendarView.dataSource = self
    }
}

extension HomeViewController: TodayRoutineDelegate {
    func didTappedAddChallengeButton() {
        self.viewModel?.didTappedAddChallengeButton()
    }
}

extension HomeViewController: UITableViewDelegate {
    func configureDataSource() -> DataSource {
        let dataSource = DataSource(tableView: todayRoutineView.tableView) { tableView, indexPath, _ in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RoutineTableViewCell.identifier,
                                                     for: indexPath) as? RoutineTableViewCell,
                  let routines = self.viewModel?.todayRoutines.value else { return UITableViewCell() }
            cell.configureCell(routine: routines[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }
        return dataSource
    }

    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let auth = UIContextualAction(style: .normal, title: nil) { [weak self] (_, _, _: @escaping (Bool) -> Void) in
            self?.viewModel?.didTappedTodayRoutineAuth(index: indexPath.row)
        }

        auth.backgroundColor = .systemGreen
        auth.title = "인증하기"
        return UISwipeActionsConfiguration(actions: [auth])
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        guard let challengeID = viewModel?.todayRoutines.value[indexPath.row].challengeID else { return }
        self.viewModel?.didTappedTodayRoutine(index: indexPath.row)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        self.viewModel?.days.value.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let day = self.viewModel?.days.value[indexPath.row]

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: DateCollectionViewCell.reuseIdentifier,
            for: indexPath) as? DateCollectionViewCell else { return UICollectionViewCell() }
        cell.setDay(day)
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = Int(collectionView.frame.width / 7)
        let height = 55
        return CGSize(width: width, height: height)
    }
}
