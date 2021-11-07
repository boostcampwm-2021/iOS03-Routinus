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
    
    private lazy var jtacMonthView: JTACMonthView = {
        let view = JTACMonthView(frame: CGRect.zero)
        view.scrollDirection = .horizontal
        view.scrollingMode = .stopAtEachCalendarFrame
        view.isPagingEnabled = true
        view.isUserInteractionEnabled = false
        view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        view.layer.cornerRadius = 15
        view.register(DateCell.self, forCellWithReuseIdentifier: "date")
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

private extension CalendarView {
    func configure() {
        configureSubviews()
    }
    
    private func configureSubviews() {
        addSubview(calendarTitle)
        calendarTitle.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.height.equalTo(50)
        }
        
        addSubview(nextMonth)
        nextMonth.snp.makeConstraints { make in
            make.centerY.equalTo(calendarTitle.snp.centerY)
            make.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        addSubview(monthLabel)
        monthLabel.snp.makeConstraints { make in
            make.centerY.equalTo(calendarTitle.snp.centerY)
            make.trailing.equalTo(nextMonth.snp.leading).offset(-10)
            make.height.equalTo(50)
        }
        
        addSubview(previousMonth)
        previousMonth.snp.makeConstraints { make in
            make.centerY.equalTo(calendarTitle.snp.centerY)
            make.trailing.equalTo(monthLabel.snp.leading).offset(-10)
            make.height.equalTo(50)
        }
        
        addSubview(jtacMonthView)
        jtacMonthView.snp.makeConstraints { make in
            make.top.equalTo(calendarTitle.snp.bottom).offset(10)
            make.width.equalToSuperview()
            make.height.equalTo(300)
        }
    }
}
