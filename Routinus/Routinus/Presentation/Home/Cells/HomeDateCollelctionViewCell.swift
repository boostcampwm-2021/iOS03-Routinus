//
//  HomeDateCollectionViewCell.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/02.
//

import UIKit

final class HomeDateCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "HomeDateCollectionViewCell"

    private lazy var achievementCharacterView: UIImageView = {
        let view = UIImageView()
        view.clipsToBounds = true
        return view
    }()

    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.textColor = UIColor(named: "DayColor")
        return label
    }()

    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE, MMMM d")
        return dateFormatter
    }()

    var day: Day? {
        didSet {
            guard let day = day else { return }

            numberLabel.text = day.number
            accessibilityLabel = dateFormatter.string(from: day.date)
            achievementRate = day.achievementRate
            updateSelectionStatus()
        }
    }

    private var achievementRate: Double? {
        didSet {
            guard let achievementRate = achievementRate else { return }

            var image: UIImage?
            if achievementRate > 0 && achievementRate < 0.2 {
                image = UIImage(named: "1-19")
            } else if achievementRate >= 0.2 && achievementRate < 0.4 {
                image = UIImage(named: "20-39")
            } else if achievementRate >= 0.4 && achievementRate < 0.66 {
                image = UIImage(named: "40-65")
            } else if achievementRate >= 0.66 && achievementRate < 1 {
                image = UIImage(named: "66-99")
            } else if achievementRate == 1 {
                image = UIImage(named: "100")
            }
            achievementCharacterView.image = image
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }

    func updateDay(_ day: Day?) {
        self.day = day
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let size = traitCollection.horizontalSizeClass == .compact ?
          min(min(frame.width, frame.height) - 10, 60) : 45
        backgroundColor = UIColor(named: "SystemBackground")

        numberLabel.anchor(leading: numberLabel.superview?.leadingAnchor,
                           paddingLeading: 5,
                           top: numberLabel.superview?.topAnchor,
                           paddingTop: 5)

        achievementCharacterView.anchor(centerX: achievementCharacterView.superview?.centerXAnchor,
                                        centerY: achievementCharacterView.superview?.centerYAnchor,
                                        width: size - 8)
        let constraint = achievementCharacterView.heightAnchor
            .constraint(equalToConstant: achievementCharacterView.frame.width)
        constraint.priority = UILayoutPriority(900)
        constraint.isActive = true
    }
}

extension HomeDateCollectionViewCell {
    private func configureViews() {
        contentView.addSubview(numberLabel)
        contentView.addSubview(achievementCharacterView)
    }

    private func updateSelectionStatus() {
        guard let day = day else { return }

        applyDefaultStyle(isWithinDisplayedMonth: day.isWithinDisplayedMonth,
                          weekday: Calendar.current.component(.weekday, from: day.date))
        if day.isSelected {
            achievementCharacterView.isHidden = false
        }
    }

    private func applyDefaultStyle(isWithinDisplayedMonth: Bool, weekday: Int) {
        let color: UIColor?
        switch weekday {
        case 1:
            color = UIColor(named: "SundayColor")
        case 7:
            color = UIColor(named: "SaturdayColor")
        default:
            color = UIColor(named: "DayColor")
        }

        numberLabel.textColor = isWithinDisplayedMonth ? color : UIColor(named: "LightGray")
        achievementCharacterView.isHidden = true
    }
}
