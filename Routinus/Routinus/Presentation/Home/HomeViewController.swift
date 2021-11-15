//
//  HomeViewController.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/01.
//

import Combine
import UIKit

import JTAppleCalendar
import SnapKit

final class HomeViewController: UIViewController {
    private lazy var scrollView: UIScrollView = UIScrollView()
    private lazy var contentView: UIView = UIView()
    private lazy var continuityView = ContinuityView()
    private lazy var todayRoutineView = TodayRoutineView()
    private lazy var calendarView = CalendarView()

    private var viewModel: HomeViewModelIO?
    private var cancellables = Set<AnyCancellable>()
    private var achievements: [Achievement] = []
    private var calendarDelegate = CalendarDelegate.shared

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
}

extension HomeViewController {
    private func configureViews() {
        self.view.backgroundColor = .white
        self.configureNavigationBar()

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
            make.top.equalTo(todayRoutineView.snp.bottom).offset(10)
            make.width.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
            make.height.equalTo(350)
            make.bottom.equalToSuperview().offset(-50)
        }
    }

    private func configureNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .systemGray
        self.navigationItem.backBarButtonItem = backBarButtonItem
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

        self.viewModel?.achievement
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] achievements in
                guard let self = self else { return }
                self.achievements = achievements
                self.calendarDelegate.calendar = self.achievements
                self.setRangeDates()
            })
            .store(in: &cancellables)
    }

    private func configureDelegates() {
        todayRoutineView.delegate = self
        todayRoutineView.dataSource = self
        todayRoutineView.challengeAdddelegate = self

        calendarDelegate.calendar = achievements
        calendarDelegate.formatter = viewModel?.formatter

        calendarView.delegate = calendarDelegate
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

extension HomeViewController: JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        todayDate()
        return ConfigurationParameters(startDate: Date(), endDate: Date())
    }

    func todayDate() {
        let formatter = viewModel?.formatter
        formatter?.dateFormat = "yyyy년 MM월"
        let currentDate = formatter?.string(from: Date())
        calendarView.setMonthLabelText(currentDate ?? "")
    }

    func setRangeDates() {
        guard let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian) else { return }
        for dates in achievements {
            let formatter = viewModel?.formatter
            formatter?.dateFormat = "yyyyMMdd"
            guard let dateData = formatter?.date(from: "\(dates.yearMonth)\(dates.day)") else { return }

            var rangeDate: [Date] = []
            let dateComponent = DateComponents(year: dateData.year, month: dateData.month, day: dateData.day)
            guard let date = gregorianCalendar.date(from: dateComponent as DateComponents) else { return }

            rangeDate.append(date)
            calendarView.selectDates(rangeDate)
            calendarView.reloadDates(rangeDate)
        }
    }
}
