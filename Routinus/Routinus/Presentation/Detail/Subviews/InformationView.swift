//
//  InformationView.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/16.
//

import UIKit

final class InformationView: UIView {

    private lazy var stackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.backgroundColor = .systemBackground
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()

    private lazy var titleStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var categoryImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = UIColor(named: "Black")
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()

    private lazy var weekStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()

    private lazy var weekTitleLabel: UILabel = {
        var label = UILabel()
        label.text = "기간"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor(named: "DayColor")
        return label
    }()

    private lazy var weekView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor(named: "WeekColor")
        return view
    }()

    private lazy var weekLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor(named: "Black")
        return label
    }()

    private lazy var endDateStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()

    private lazy var endDateTitleLabel: UILabel = {
        var label = UILabel()
        label.text = "종료일"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor(named: "DayColor")
        return label
    }()

    private lazy var endDateLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .right
        label.textColor = UIColor(named: "DayColor")
        return label
    }()

    private lazy var introductionTitleLabel: UILabel = {
        var label = UILabel()
        label.text = "소개"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = UIColor(named: "DayColor")
        return label
    }()

    private lazy var introductionView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = .systemGray6
        return view
    }()

    private lazy var introductionLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor(named: "DayColor")
        return label
    }()

    private lazy var emptyView: UIView = {
        var view = UIView()
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureSubviews()
    }

    convenience init() {
        self.init(frame: CGRect.zero)
    }
}

extension InformationView {
    private func configureSubviews() {
        addSubview(stackView)
        stackView.anchor(edges: self)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

        stackView.addArrangedSubview(titleStackView)
        titleStackView.anchor(height: 20)

        titleStackView.addArrangedSubview(categoryImageView)
        categoryImageView.heightAnchor.constraint(equalTo: categoryImageView.widthAnchor, multiplier: 1).isActive = true

        titleStackView.addArrangedSubview(titleLabel)

        stackView.addArrangedSubview(weekStackView)
        weekStackView.anchor(height: 20)

        weekStackView.addArrangedSubview(weekTitleLabel)
        weekTitleLabel.anchor(width: 40)

        weekView.addSubview(weekLabel)
        weekLabel.anchor(centerX: weekView.centerXAnchor,
                         centerY: weekView.centerYAnchor)

        weekStackView.addArrangedSubview(weekView)
        weekView.anchor(width: 60)

        stackView.addArrangedSubview(endDateStackView)

        endDateStackView.addArrangedSubview(endDateTitleLabel)
        endDateTitleLabel.anchor(width: 40)

        endDateStackView.addArrangedSubview(endDateLabel)
        endDateLabel.anchor(width: 170)

        stackView.addArrangedSubview(introductionTitleLabel)
        introductionTitleLabel.anchor(height: 20)

        stackView.addArrangedSubview(introductionView)
        introductionView.addSubview(introductionLabel)
        introductionLabel.anchor(horizontal: introductionView, paddingHorizontal: 10,
                                 vertical: introductionView, paddingVertical: 10)
    }

    func update(to challenge: Challenge) {
        guard let endDate = challenge.endDate?.toDateWithWeekdayString() else { return }
        let image = challenge.category == .exercise
                    || challenge.category == .lifeStyle
                        ? UIImage(named: challenge.category.symbol)
                        : UIImage(systemName: challenge.category.symbol)
        categoryImageView.image = image
        titleLabel.text = challenge.title
        weekLabel.text = "\(challenge.week)주"
        endDateLabel.text = endDate
        introductionLabel.text = challenge.introduction
    }
}
