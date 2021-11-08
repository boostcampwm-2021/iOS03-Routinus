//
//  CalendarView.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/07.
//

import UIKit

import JTAppleCalendar
import SnapKit

final class CalendarView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "요약"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()

    private lazy var previousMonthButton: UIButton = {
        let button = UIButton()
        button.setTitle("<", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    private lazy var nextMonthButton: UIButton = {
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

    private lazy var jtacMonthView: JTACMonthView = {
        let view = JTACMonthView(frame: CGRect.zero)
        view.scrollDirection = .horizontal
        view.scrollingMode = .stopAtEachCalendarFrame
        view.isPagingEnabled = true
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        view.layer.cornerRadius = 15
        view.register(DateCell.self, forCellWithReuseIdentifier: DateCell.identifier)
        view.register(DateHeader.self,
                      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                      withReuseIdentifier: DateHeader.identifier)
        return view
    }()

    weak var delegate: JTACMonthViewDelegate? {
        didSet {
            jtacMonthView.calendarDelegate = delegate
        }
    }

    weak var dataSource: JTACMonthViewDataSource? {
        didSet {
            jtacMonthView.calendarDataSource = dataSource
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    convenience init() {
        self.init(frame: CGRect.zero)
    }

    func setMonthLabelText(_ text: String) {
        monthLabel.text = text
    }

    func selectDates(_ dates: [Date]) {
        jtacMonthView.selectDates(dates)
    }

    func reloadDates(_ dates: [Date]) {
        jtacMonthView.reloadDates(dates)
    }
}

extension CalendarView {
    private func configure() {
        configureSubviews()
    }

    private func configureSubviews() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.height.equalTo(50)
        }

        addSubview(nextMonthButton)
        nextMonthButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalToSuperview()
            make.height.equalTo(50)
        }

        addSubview(monthLabel)
        monthLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalTo(nextMonthButton.snp.leading).offset(-10)
            make.height.equalTo(50)
        }

        addSubview(previousMonthButton)
        previousMonthButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalTo(monthLabel.snp.leading).offset(-10)
            make.height.equalTo(50)
        }

        addSubview(jtacMonthView)
        jtacMonthView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.width.equalToSuperview()
            make.height.equalTo(300)
        }
    }
}
