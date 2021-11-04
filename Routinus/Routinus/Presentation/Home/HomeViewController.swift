//
//  HomeViewController.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/01.
//

import JTAppleCalendar
import SnapKit
import UIKit

struct Routine {
    let category: Category
    let challengeTitle: String
    let percentage: Float
}

struct RoutineData {
    let date: String
    let percentage: Double
}

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

    private lazy var initContinuityLabel: UILabel = {
        let label = UILabel()
        label.text = "시작이 반이다"
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        return label
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
        label.text = "yyyy.nn월"
        return label
    }()

    let dummyList: [Routine] = [
        Routine(category: .exercise, challengeTitle: "30분 이상 걷기", percentage: 0.7),
        Routine(category: .lifeStyle, challengeTitle: "1L이상 물마시기", percentage: 0.6)
    ]

    let dummyCalendar = [RoutineData(date: "20211102", percentage: 0.2),
                         RoutineData(date: "20211104", percentage: 0.8),
                         RoutineData(date: "20211105", percentage: 1),
                         RoutineData(date: "20211106", percentage: 0.5),
                         RoutineData(date: "20211107", percentage: 0.4)]

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
    private func configureViews() {
        self.view.backgroundColor = .white

        self.view.addSubview(scrollView)
        self.scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }

        self.scrollView.addSubview(contentView)
        self.contentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.top.bottom.equalToSuperview()
        }

        self.contentView.addSubview(continuityView)
        self.continuityView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalToSuperview()
            make.height.equalTo(80)
        }

        configureContinuityView()
        configureRoutineViews()
        configureCalendarTitle()
    }

    private func configureContinuityView(){
        self.continuityView.addSubview(seedImage)
        self.seedImage.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }

        // TODO: - firebase 데이터 연동
        let day = 0
        if day == 0 {
            self.continuityView.addSubview(initContinuityLabel)
            self.initContinuityLabel.snp.makeConstraints { make in
                make.leading.equalTo(self.seedImage.snp.trailing).offset(20)
                make.centerY.equalToSuperview()
            }
        } else {
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
        }
    }

    private func configureRoutineViews() {
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

        self.contentView.addSubview(tableView)
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(todayRoutineTitle.snp.bottom).offset(10)
            make.width.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
            make.height.equalTo(200)
        }
    }

    private func configureCalendarTitle() {
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
        // - TODO: 테이블뷰 높이 조정 데이터 바인딩 쪽으로 옮기기 
        self.tableView.snp.makeConstraints { make in
            make.height.equalTo(60*dummyList.count)
        }
        return dummyList.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RoutineCell.identifier, for: indexPath)
                as? RoutineCell else { return UITableViewCell() }
        cell.configureCell(routine: dummyList[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let auth = UIContextualAction(style: .normal, title: "인증하기") { (UIContextualAction, UIView, success: @escaping (Bool) -> Void) in
            // TODO: - 화면 이동하기
        }
        // TODO: - 인증하기 버튼 배경색 정하기
        auth.backgroundColor = .black
        return UISwipeActionsConfiguration(actions: [auth])
    }
}

extension HomeViewController {
    private func addCalendar() {
        let delegate = CalendarDelegate.shared
        delegate.dummyCalendar = dummyCalendar
//        delegate.formatter = viewModel.formatter

        calendarView.scrollDirection = .horizontal
        calendarView.scrollingMode = .stopAtEachCalendarFrame
        calendarView.isPagingEnabled = true
        calendarView.isUserInteractionEnabled = false
        calendarView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        calendarView.layer.cornerRadius = 15
        calendarView.register(DateCell.self, forCellWithReuseIdentifier: "date")
        calendarView.register(DateHeader.self,
                              forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                              withReuseIdentifier: DateHeader.identifier)
        calendarView.calendarDelegate = delegate
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

extension HomeViewController: JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        todayDate()
        setRangeDates()
        return ConfigurationParameters(startDate: Date(), endDate: Date())
    }

    func todayDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        let currentDate = formatter.string(from: Date())

        monthLabel.text = currentDate + "월"
    }

    func setRangeDates() {
        guard let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian) else { return }
        for dates in dummyCalendar {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            guard let dateData = dateFormatter.date(from: dates.date) else { return }

            var rangeDate: [Date] = []
            let dateComponent = DateComponents(year: dateData.year, month: dateData.month, day: dateData.day)
            let date = gregorianCalendar.date(from: dateComponent as DateComponents)!
            rangeDate.append(date)
            calendarView.selectDates(rangeDate)
        }
    }
}
