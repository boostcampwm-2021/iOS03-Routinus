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
        button.setTitle("오늘", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.isHidden = true

        button.addTarget(self, action: #selector(didTappedTodayButton), for: .touchUpInside)
        return button
    }()

    private lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.text = "Month"
        label.textAlignment = .center
        return label
    }()

    private lazy var previousMonthButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .black

        button.addTarget(self, action: #selector(didTappedPreviousMonthButton), for: .touchUpInside)
        return button
    }()

    private lazy var nextMonthButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .black

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
        self.backgroundColor = .systemGroupedBackground

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

        todayButton.anchor(left: todayButton.superview?.leftAnchor, paddingLeft: 15,
                           top: todayButton.superview?.topAnchor, paddingTop: 15)

        nextMonthButton.anchor(right: nextMonthButton.superview?.rightAnchor, paddingRight: 10,
                               centerY: todayButton.centerYAnchor,
                               width: 36, height: 36)

        monthLabel.anchor(right: nextMonthButton.leftAnchor, paddingRight: 10,
                          centerY: todayButton.centerYAnchor)

        previousMonthButton.anchor(right: monthLabel.leftAnchor, paddingRight: 10,
                                   centerY: todayButton.centerYAnchor,
                                   width: 36, height: 36)

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
