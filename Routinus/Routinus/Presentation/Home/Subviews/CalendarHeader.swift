//
//  CalendarHeader.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/02.
//

import UIKit

final class CalendarHeader: UIView {
    private lazy var todayButton: UIButton = {
        let button = UIButton()
        button.setTitle("Today", for: .normal)
        button.setTitleColor(UIColor(named: "Black"), for: .normal)
        button.backgroundColor = UIColor(named: "MainColor")?.withAlphaComponent(0.5)
        button.isHidden = true
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTappedTodayButton), for: .touchUpInside)
        return button
    }()

    private lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.text = "Month"
        label.textAlignment = .center
        return label
    }()

    private lazy var previousMonthButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = UIColor(named: "Black")

        button.addTarget(self, action: #selector(didTappedPreviousMonthButton), for: .touchUpInside)
        return button
    }()

    private lazy var nextMonthButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor =  UIColor(named: "Black")

        button.addTarget(self, action: #selector(didTappedNextMonthButton), for: .touchUpInside)
        return button
    }()

    private lazy var dayOfWeekStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.label.withAlphaComponent(0.2)
        return view
    }()

    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale.autoupdatingCurrent
        dateFormatter.setLocalizedDateFormatFromTemplate("y.MMM")
        return dateFormatter
    }()

    var baseDate = Date() {
        didSet {
            monthLabel.text = dateFormatter.string(from: baseDate)
            todayButton.isHidden = baseDate.toDateString() == Date().toDateString()
        }
    }

    private let didTappedLastMonthCompletionHandler: (() -> Void)
    private let didTappedNextMonthCompletionHandler: (() -> Void)
    private let didTappedTodayCompletionHandler: (() -> Void)

    init(didTappedLastMonthCompletionHandler: @escaping (() -> Void),
         didTappedNextMonthCompletionHandler: @escaping (() -> Void),
         didTappedTodayCompletionHandler: @escaping (() -> Void)) {
        self.didTappedLastMonthCompletionHandler = didTappedLastMonthCompletionHandler
        self.didTappedNextMonthCompletionHandler = didTappedNextMonthCompletionHandler
        self.didTappedTodayCompletionHandler = didTappedTodayCompletionHandler

        super.init(frame: CGRect.zero)

        configureViews()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension CalendarHeader {
    private func dayOfWeekLetter(for dayNumber: Int) -> String {
        switch dayNumber {
        case 1:
            return "sun".localized
        case 2:
            return "mon".localized
        case 3:
            return "tue".localized
        case 4:
            return "wed".localized
        case 5:
            return "thu".localized
        case 6:
            return "fri".localized
        case 7:
            return "sat".localized
        default:
            return ""
        }
    }

    private func configureViews() {
        self.backgroundColor = .tertiarySystemGroupedBackground

        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.layer.cornerCurve = .continuous
        self.layer.cornerRadius = 15

        self.addSubview(todayButton)
        self.addSubview(monthLabel)
        self.addSubview(previousMonthButton)
        self.addSubview(nextMonthButton)
        self.addSubview(dayOfWeekStackView)
        self.addSubview(separatorView)

        for dayNumber in 1...7 {
            let dayLabel = UILabel()
            dayLabel.font = .systemFont(ofSize: 12, weight: .bold)
            dayLabel.textColor = UIColor(named: "DayColor")
            dayLabel.textAlignment = .center
            dayLabel.text = dayOfWeekLetter(for: dayNumber)

            dayOfWeekStackView.addArrangedSubview(dayLabel)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        previousMonthButton.anchor(leading: previousMonthButton.superview?.leadingAnchor, paddingLeading: 10,
                                   top: previousMonthButton.superview?.topAnchor, paddingTop: 15,
                                   width: 36, height: 36)

        monthLabel.anchor(leading: previousMonthButton.trailingAnchor, paddingLeading: 10,
                          centerY: previousMonthButton.centerYAnchor,
                          width: 100)

        nextMonthButton.anchor(leading: monthLabel.trailingAnchor, paddingLeading: 10,
                               centerY: previousMonthButton.centerYAnchor,
                               width: 36, height: 36)

        todayButton.anchor(trailing: todayButton.superview?.trailingAnchor, paddingTrailing: 15,
                           centerY: previousMonthButton.centerYAnchor,
                           width: 80)

        dayOfWeekStackView.anchor(horizontal: dayOfWeekStackView.superview,
                                  bottom: separatorView.bottomAnchor, paddingBottom: 5)

        separatorView.anchor(horizontal: separatorView.superview,
                             bottom: separatorView.superview?.bottomAnchor,
                             height: 1)
    }

    @objc func didTappedPreviousMonthButton() {
        didTappedLastMonthCompletionHandler()
    }

    @objc func didTappedNextMonthButton() {
        didTappedNextMonthCompletionHandler()
    }

    @objc func didTappedTodayButton() {
        didTappedTodayCompletionHandler()
    }
}
