//
//  HomeViewController.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/01.
//

import Combine
import UIKit

import SnapKit

final class HomeViewController: UIViewController {
    private lazy var scrollView: UIScrollView = UIScrollView()
    private lazy var contentView: UIView = UIView()
    private lazy var continuityView = ContinuityView()
    private lazy var todayRoutineView = TodayRoutineView()
    private lazy var calendarView = CalendarView(viewModel: viewModel)

    private var viewModel: HomeViewModelIO?
    private var cancellables = Set<AnyCancellable>()
    private var achievements: [Achievement] = []

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

    override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator
    ) {
        super.viewWillTransition(to: size, with: coordinator)
        calendarView.reloadData()
    }
}

extension HomeViewController {
    private func configureViews() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true

        self.view.addSubview(scrollView)
        self.scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }

        self.scrollView.addSubview(contentView)
        self.contentView.snp.makeConstraints { make in
            make.width.centerX.top.bottom.equalToSuperview()
        }

        self.contentView.addSubview(continuityView)
        self.continuityView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(80)
        }

        self.contentView.addSubview(todayRoutineView)
        self.todayRoutineView.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.continuityView.snp.bottom).offset(25)
        }

        self.contentView.addSubview(calendarView)
        self.calendarView.snp.makeConstraints { make in
            make.top.equalTo(todayRoutineView.snp.bottom).offset(20)
            make.width.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            make.height.equalTo(450)
        }

        self.contentView.snp.makeConstraints { make in
            make.bottom.equalTo(self.calendarView.snp.bottom)
        }
    }

    private func configureViewModel() {
        self.viewModel?.user
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] user in
                guard let self = self else { return }
                self.navigationItem.title = user.name + "님의 Routine"
                self.continuityView.configureContents(with: user)
            })
            .store(in: &cancellables)

        self.viewModel?.todayRoutine
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] routines in
                guard let self = self else { return }
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
        todayRoutineView.dataSource = self
        todayRoutineView.challengeAdddelegate = self

        calendarView.delegate = self
        calendarView.dataSource = self
    }
}

extension HomeViewController: TodayRoutineDelegate {
    func didTappedAddChallengeButton() {
        self.viewModel?.didTappedAddChallengeButton()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.todayRoutine.value.count ?? 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RoutineCell.identifier, for: indexPath)
                as? RoutineCell,
              let routines = self.viewModel?.todayRoutine.value else { return UITableViewCell() }

        cell.configureCell(routine: routines[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let auth = UIContextualAction(style: .normal, title: nil) { [weak self] (_, _, _: @escaping (Bool) -> Void) in
            self?.viewModel?.didTappedTodayRoutineAuth(index: indexPath.row)
        }

        let largeConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .bold, scale: .large)
        auth.image = UIImage(systemName: "camera", withConfiguration: largeConfig)?
                        .withTintColor(.white).circularBackground(nil)
        auth.backgroundColor = .systemBackground
        auth.title = "auth"
        return UISwipeActionsConfiguration(actions: [auth])
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let challengeID = viewModel?.todayRoutine.value[indexPath.row].challengeID else { return }
        self.viewModel?.didTappedTodayRoutine(index: indexPath.row)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewModel?.days.value.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let day = self.viewModel?.days.value[indexPath.row]

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CalendarDateCell.reuseIdentifier,
            for: indexPath) as? CalendarDateCell else { return UICollectionViewCell() }
        cell.day = day
        cell.achievementRate = day?.achievementRate
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = Int(collectionView.frame.width / 7)
        let height = 55
        return CGSize(width: width, height: height)
    }
}
