//
//  DateHeader.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/02.
//

import UIKit

import JTAppleCalendar
import SnapKit

final class DateHeader: JTACMonthReusableView {
    static let identifier = "day"
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureDayStack()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureDayStack()
    }

    private lazy var dayStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalCentering
        return stack
    }()

    private lazy var sunLabel: UILabel = {
        let label = UILabel()
        label.text = "일"
        label.textColor = UIColor(named: "SundayColor")
        return label
    }()

    private lazy var monLabel: UILabel = {
        let label = UILabel()
        label.text = "월"
        label.textColor = UIColor(named: "DayColor")
        return label
    }()

    private lazy var tueLabel: UILabel = {
        let label = UILabel()
        label.text = "화"
        label.textColor = UIColor(named: "DayColor")
        return label
    }()

    private lazy var wedLabel: UILabel = {
        let label = UILabel()
        label.text = "수"
        label.textColor = UIColor(named: "DayColor")
        return label
    }()

    private lazy var thuLabel: UILabel = {
        let label = UILabel()
        label.text = "목"
        label.textColor = UIColor(named: "DayColor")
        return label
    }()

    private lazy var friLabel: UILabel = {
        let label = UILabel()
        label.text = "금"
        label.textColor = UIColor(named: "DayColor")
        return label
    }()

    private lazy var satLabel: UILabel = {
        let label = UILabel()
        label.text = "토"
        label.textColor = UIColor(named: "SaturdayColor")
        return label
    }()

    func configureDayStack() {
        self.addSubview(dayStack)
        self.dayStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        let dayLabels = [sunLabel, monLabel, tueLabel, wedLabel, thuLabel, friLabel, satLabel]
        dayLabels.forEach {
            $0.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
            dayStack.addArrangedSubview($0)
        }
    }
}
