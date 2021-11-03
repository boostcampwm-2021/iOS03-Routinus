//
//  HomeViewController.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/01.
//

import UIKit
import SnapKit
import JTAppleCalendar

class HomeViewController: UIViewController {
    private let scrollView: UIScrollView = UIScrollView()
    private let contentView: UIView = UIView()

    private lazy var continuityView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 5

        return view
    }()

    private lazy var seedImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    private lazy var continuityDayLabel: UILabel = {
        let label = UILabel()

        label.text = "0"
        label.font = UIFont.boldSystemFont(ofSize: 48)
        return label
    }()

    private lazy var continuityInfoLabel: UILabel = {
        let label = UILabel()

        label.text = "일 연속 달성"
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        return label
    }()

    private lazy var todayRoutineView: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var todayRoutineTitle: UILabel = {
        let label = UILabel()
        label.text = "오늘 루틴"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()

    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .black
        return button
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)

        tableView.estimatedRowHeight = 100
        return tableView
    }()

    private lazy var calendarTitleView = UIView()

    private lazy var calendarTitle: UILabel = {
        let label = UILabel()
        label.text = "요약"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()

    private lazy var previousMonth: UIButton = {
        let button = UIButton()
        button.setTitle("<", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    private lazy var nextMonth: UIButton = {
        let button = UIButton()
        button.setTitle(">", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    private lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.text = "2021.11월"
        return label
    }()

    let dummyList: [Routine] = [
        Routine(categoryImage: "pencil", categoryText: "물마시기"),
        Routine(categoryImage: "pencil", categoryText: "30분 이상 물 마시기")
    ]

    private let calendarView = JTACMonthView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(RoutineCell.self, forCellReuseIdentifier: RoutineCell.identifier)

        configureViews()
        addCalendar()
    }
}

extension HomeViewController {
    func configureViews() {
        self.view.backgroundColor = .white

        self.view.addSubview(scrollView)
        self.scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }

        self.scrollView.addSubview(contentView)
        self.contentView.snp.makeConstraints { make in
            make.width.top.equalToSuperview()
        }

        self.contentView.addSubview(continuityView)
        self.continuityView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)

            make.top.equalToSuperview()
            make.height.equalTo(80)
        }

        self.continuityView.addSubview(seedImage)
        self.seedImage.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }

        self.continuityView.addSubview(continuityDayLabel)
        self.continuityDayLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.seedImage.snp.trailing).offset(20)
            make.centerY.equalToSuperview()
        }

        self.continuityView.addSubview(continuityInfoLabel)
        self.continuityInfoLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.continuityDayLabel.snp.trailing).offset(5)
            make.lastBaseline.equalTo(self.continuityDayLabel.snp.lastBaseline).offset(-2)
        }

        configureRoutineViews()
        configureCalendarTitle()
    }

    func configureRoutineViews() {
        self.contentView.addSubview(todayRoutineView)
        self.todayRoutineView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.continuityView.snp.bottom).offset(25)
        }

        self.todayRoutineView.addSubview(todayRoutineTitle)
        self.todayRoutineTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview()
        }

        self.todayRoutineView.addSubview(addButton)
        self.addButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalToSuperview()
        }

        self.todayRoutineView.addSubview(tableView)
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(todayRoutineTitle.snp.bottom).offset(10)
            make.width.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            make.height.equalTo(200)
        }
    }

    func configureCalendarTitle() {
        self.contentView.addSubview(calendarTitleView)
        calendarTitleView.snp.makeConstraints { make in
            make.top.equalTo(self.tableView.snp.bottom).offset(10)
            make.width.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }

        self.calendarTitleView.addSubview(self.calendarTitle)
        self.calendarTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }

        self.calendarTitleView.addSubview(self.nextMonth)
        self.nextMonth.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        self.calendarTitleView.addSubview(self.monthLabel)
        self.monthLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self.nextMonth.snp.leading).offset(-10)
            make.centerY.equalToSuperview()
        }

        self.calendarTitleView.addSubview(self.previousMonth)
        self.previousMonth.snp.makeConstraints { make in
            make.trailing.equalTo(self.monthLabel.snp.leading).offset(-10)
            make.centerY.equalToSuperview()
        }

    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyList.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RoutineCell.identifier, for: indexPath)
                as? RoutineCell else { return UITableViewCell() }
        cell.configureCell(routine: dummyList[indexPath.row])

        return cell
    }
}

struct Routine {
    let categoryImage: String
    let categoryText: String
}

extension HomeViewController {
    private func addCalendar() {
        calendarView.scrollDirection = .vertical
        calendarView.scrollingMode = .stopAtEachCalendarFrame
        calendarView.backgroundColor = .white
        calendarView.register(DateCell.self, forCellWithReuseIdentifier: "date")
        calendarView.register(DateHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                              withReuseIdentifier: DateHeader.identifier)
        calendarView.calendarDelegate = self
        calendarView.calendarDataSource = self

        self.contentView.addSubview(calendarView)
        calendarView.snp.makeConstraints { make in
            make.top.equalTo(self.calendarTitleView.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(300)
        }

        self.contentView.snp.makeConstraints { make in
            make.bottom.equalTo(self.calendarView.snp.bottom)
        }
    }
}

extension HomeViewController: JTACMonthViewDelegate {
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath)
    -> JTACDayCell {
        guard let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "date", for: indexPath)
                as? DateCell else { return JTACDayCell() }
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }

    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date,
                  cellState: CellState, indexPath: IndexPath) {
        guard let cell = cell as? DateCell else { return }
        configureCell(view: cell, cellState: cellState)
    }

    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }

    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        configureCell(view: cell, cellState: cellState)
    }

    private func configureCell(view: JTACDayCell?, cellState: CellState) {
        guard let cell = view as? DateCell  else { return }
        cell.dateLabel.text = cellState.text
        handleCellTextColor(cell: cell, cellState: cellState)
        handleCellSelected(cell: cell, cellState: cellState)
    }

    private func handleCellTextColor(cell: DateCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = UIColor.black
        } else {
            cell.dateLabel.textColor = UIColor.gray
        }
    }

    private func handleCellSelected(cell: DateCell, cellState: CellState) {
        if cellState.isSelected {
            cell.selectedView.layer.cornerRadius = cell.selectedView.frame.width / 2
            cell.selectedView.isHidden = false
        } else {
            cell.selectedView.isHidden = true
        }
    }
}

extension HomeViewController: JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy MM dd"
      let startDate = formatter.date(from: "2021 11 01")!
      let endDate = Date()
      return ConfigurationParameters(startDate: startDate, endDate: endDate)
    }
}
