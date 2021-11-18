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
        stackView.backgroundColor = .white
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
        imageView.tintColor = .black
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
        label.textColor = .darkGray
        return label
    }()

    private lazy var weekView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor(named: "SundayColor")
        return view
    }()

    private lazy var weekLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .darkGray
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
        label.textColor = .darkGray
        return label
    }()

    private lazy var endDateLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .right
        label.textColor = .darkGray
        return label
    }()

    private lazy var introductionTitleLabel: UILabel = {
        var label = UILabel()
        label.text = "소개"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .darkGray
        return label
    }()

    private lazy var introductionView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = .systemGray5
        return view
    }()

    private lazy var introductionLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .darkGray
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

        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

        stackView.addArrangedSubview(titleStackView)
        titleStackView.heightAnchor.constraint(equalToConstant: 20).isActive = true

        titleStackView.addArrangedSubview(categoryImageView)
        categoryImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        categoryImageView.heightAnchor.constraint(equalTo: categoryImageView.widthAnchor, multiplier: 1).isActive = true

        titleStackView.addArrangedSubview(titleLabel)
        titleLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

        stackView.addArrangedSubview(weekStackView)
        weekStackView.heightAnchor.constraint(equalToConstant: 20).isActive = true

        weekStackView.addArrangedSubview(weekTitleLabel)
        weekTitleLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        weekTitleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

        weekView.addSubview(weekLabel)
        weekLabel.translatesAutoresizingMaskIntoConstraints = false
        weekLabel.centerXAnchor.constraint(equalTo: weekView.centerXAnchor).isActive = true
        weekLabel.centerYAnchor.constraint(equalTo: weekView.centerYAnchor).isActive = true

        weekStackView.addArrangedSubview(weekView)
        weekView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        weekView.heightAnchor.constraint(equalToConstant: 20).isActive = true

        stackView.addArrangedSubview(endDateStackView)
        endDateStackView.heightAnchor.constraint(equalToConstant: 20).isActive = true

        endDateStackView.addArrangedSubview(endDateTitleLabel)
        endDateTitleLabel.widthAnchor.constraint(equalToConstant: 40).isActive = true
        endDateTitleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

        endDateStackView.addArrangedSubview(endDateLabel)
        endDateLabel.widthAnchor.constraint(equalToConstant: 170).isActive = true
        endDateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

        stackView.addArrangedSubview(introductionTitleLabel)
        introductionTitleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

        stackView.addArrangedSubview(introductionView)
        introductionView.addSubview(introductionLabel)

        introductionLabel.translatesAutoresizingMaskIntoConstraints = false
        introductionLabel.leadingAnchor.constraint(equalTo: introductionView.leadingAnchor, constant: 10).isActive = true
        introductionLabel.trailingAnchor.constraint(equalTo: introductionView.trailingAnchor, constant: -10).isActive = true
        introductionLabel.topAnchor.constraint(equalTo: introductionView.topAnchor, constant: 10).isActive = true
        introductionLabel.bottomAnchor.constraint(equalTo: introductionView.bottomAnchor, constant: -10).isActive = true

    }

    func update(to challenge: Challenge) {
        guard let endDate = challenge.endDate?.toDateWithWeekdayString() else { return }
        let image = challenge.category == .exercise || challenge.category == .lifeStyle ? UIImage(named: challenge.category.symbol) : UIImage(systemName: challenge.category.symbol)
        categoryImageView.image = image
        titleLabel.text = challenge.title
        weekLabel.text = "\(challenge.week)주"
        endDateLabel.text = endDate
        introductionLabel.text = challenge.introduction
    }
}
