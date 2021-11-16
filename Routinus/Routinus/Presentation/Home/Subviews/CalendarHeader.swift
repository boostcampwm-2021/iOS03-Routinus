//
//  CalendarHeader.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/02.
//

import UIKit

final class CalendarHeader: UIView {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.text = "요약"
        return label
    }()

    lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.text = "Month"
        return label
    }()

    lazy var previousMonthButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .black

        button.addTarget(self, action: #selector(didTappedPreviousMonthButton), for: .touchUpInside)
        return button
    }()

    lazy var nextMonthButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .black

        button.addTarget(self, action: #selector(didTappedNextMonthButton), for: .touchUpInside)
        return button
    }()

    lazy var dayOfWeekStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        return stackView
    }()

    lazy var separatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
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
        }
    }

    let didTappedLastMonthCompletionHandler: (() -> Void)
    let didTappedNextMonthCompletionHandler: (() -> Void)

    init(
        didTappedLastMonthCompletionHandler: @escaping (() -> Void),
        didTappedNextMonthCompletionHandler: @escaping (() -> Void)
    ) {
        self.didTappedLastMonthCompletionHandler = didTappedLastMonthCompletionHandler
        self.didTappedNextMonthCompletionHandler = didTappedNextMonthCompletionHandler

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
            return "S"
        case 2:
            return "M"
        case 3:
            return "T"
        case 4:
            return "W"
        case 5:
            return "T"
        case 6:
            return "F"
        case 7:
            return "S"
        default:
            return ""
        }
    }

    private func configureViews() {
        self.translatesAutoresizingMaskIntoConstraints = false

        self.backgroundColor = .systemGroupedBackground

        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.layer.cornerCurve = .continuous
        self.layer.cornerRadius = 15

        self.addSubview(titleLabel)
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

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),

            nextMonthButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            nextMonthButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),

            monthLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            monthLabel.trailingAnchor.constraint(equalTo: nextMonthButton.leadingAnchor, constant: -10),

            previousMonthButton.trailingAnchor.constraint(equalTo: monthLabel.leadingAnchor, constant: -10),
            previousMonthButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),

            dayOfWeekStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dayOfWeekStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dayOfWeekStackView.bottomAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: -5),

            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    @objc func didTappedPreviousMonthButton() {
        didTappedLastMonthCompletionHandler()
    }

    @objc func didTappedNextMonthButton() {
        didTappedNextMonthCompletionHandler()
    }
}
