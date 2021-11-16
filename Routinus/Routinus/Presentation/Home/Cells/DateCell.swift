//
//  DateCell.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/02.
//

import UIKit

final class CalendarDateCell: UICollectionViewCell {
    static let reuseIdentifier = "dateCell"

    private lazy var selectionBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = UIColor(named: "MainColor")
        return view
    }()

    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .label
        return label
    }()

    private lazy var accessibilityDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE, MMMM d")
        return dateFormatter
    }()

    var day: Day? {
        didSet {
            guard let day = day else { return }

            numberLabel.text = day.number
            accessibilityLabel = accessibilityDateFormatter.string(from: day.date)
            updateSelectionStatus()
        }
    }

    var achievementRate: Double? {
        didSet {
            guard let achievementRate = achievementRate else { return }
            selectionBackgroundView.alpha = achievementRate
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(selectionBackgroundView)
        contentView.addSubview(numberLabel)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        contentView.addSubview(selectionBackgroundView)
        contentView.addSubview(numberLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        NSLayoutConstraint.deactivate(selectionBackgroundView.constraints)

        let size = traitCollection.horizontalSizeClass == .compact ?
          min(min(frame.width, frame.height) - 10, 60) : 45

        NSLayoutConstraint.activate([
          numberLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
          numberLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

          selectionBackgroundView.centerYAnchor
            .constraint(equalTo: numberLabel.centerYAnchor),
          selectionBackgroundView.centerXAnchor
            .constraint(equalTo: numberLabel.centerXAnchor),
          selectionBackgroundView.widthAnchor.constraint(equalToConstant: size),
          selectionBackgroundView.heightAnchor
            .constraint(equalTo: selectionBackgroundView.widthAnchor)
        ])

        selectionBackgroundView.layer.cornerRadius = size / 2
    }
}

extension CalendarDateCell {
    func applyDayColor(_ day: Int) {
        switch day {
        case 0:
            self.numberLabel.textColor = UIColor(named: "SundayColor")
        case 6:
            self.numberLabel.textColor = UIColor(named: "SaturdayColor")
        default:
            self.numberLabel.textColor = UIColor(named: "DayColor")
        }
    }
}

private extension CalendarDateCell {
    func updateSelectionStatus() {
        guard let day = day else { return }

        if day.isSelected {
            applySelectedStyle()
        } else {
            applyDefaultStyle(isWithinDisplayedMonth: day.isWithinDisplayedMonth, weekday: Calendar.current.component(.weekday, from: day.date))
        }
    }

    var isSmallScreenSize: Bool {
        let isCompact = traitCollection.horizontalSizeClass == .compact
        let smallWidth = UIScreen.main.bounds.width <= 350
        let widthGreaterThanHeight =
        UIScreen.main.bounds.width > UIScreen.main.bounds.height

        return isCompact && (smallWidth || widthGreaterThanHeight)
    }

    func applySelectedStyle() {
        accessibilityTraits.insert(.selected)
        accessibilityHint = nil

        numberLabel.textColor = isSmallScreenSize ? UIColor(named: "MainColor") : UIColor(named: "DayColor")
        selectionBackgroundView.isHidden = isSmallScreenSize
    }

    func applyDefaultStyle(isWithinDisplayedMonth: Bool, weekday: Int) {
        accessibilityTraits.remove(.selected)
        accessibilityHint = "Tap to select"
        let color: UIColor?
        switch weekday {
        case 1:
            color = UIColor(named: "SundayColor")
        case 7:
            color = UIColor(named: "SaturdayColor")
        default:
            color = UIColor(named: "DayColor")
        }

        numberLabel.textColor = isWithinDisplayedMonth ? color : .systemGray3
        selectionBackgroundView.isHidden = true
    }
}
