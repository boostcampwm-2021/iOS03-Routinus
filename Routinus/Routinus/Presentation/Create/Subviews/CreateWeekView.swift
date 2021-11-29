//
//  CreateWeekView.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/09.
//

import UIKit

final class CreateWeekView: UIView {
    typealias Tag = CreateViewController.InputTag

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "challenge period".localized
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "enter only number".localized
        label.font = .systemFont(ofSize: 16)
        label.textColor = .systemGray
        label.numberOfLines = 2
        return label
    }()

    private lazy var weekTextField: UITextField = {
        let textField = UITextField()
        textField.text = "1"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        textField.tag = Tag.week.rawValue
        return textField
    }()

    private lazy var weekLabel: UILabel = {
        let label = UILabel()
        label.text = "week".localized
        return label
    }()

    private lazy var endDateView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 1, green: 119/255, blue: 119/255, alpha: 1).cgColor
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor(red: 252/255, green: 209/255, blue: 209/255, alpha: 1)
        return view
    }()

    private lazy var endTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "expected end date".localized
        label.font = .systemFont(ofSize: 14)
        return label
    }()

    private lazy var endDateLabel: UILabel = {
        let label = UILabel()
        label.text = "1999.01.01(금)"
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()

    weak var delegate: UITextFieldDelegate? {
        didSet {
            weekTextField.delegate = delegate
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

    func hideKeyboard() {
        weekTextField.endEditing(true)
    }
}

extension CreateWeekView {
    private func configure() {
        configureSubviews()
    }

    private func configureSubviews() {
        addSubview(titleLabel)
        titleLabel.anchor(top: titleLabel.superview?.topAnchor,
                          width: UIScreen.main.bounds.width - 40,
                          height: 24)

        addSubview(descriptionLabel)
        descriptionLabel.anchor(top: titleLabel.bottomAnchor, paddingTop: 10,
                                width: UIScreen.main.bounds.width - 40)

        addSubview(weekTextField)
        weekTextField.anchor(leading: weekTextField.superview?.leadingAnchor,
                             top: descriptionLabel.bottomAnchor, paddingTop: 20,
                             width: 50)

        addSubview(weekLabel)
        weekLabel.anchor(leading: weekTextField.trailingAnchor, paddingLeading: 10,
                         centerY: weekTextField.centerYAnchor)

        addSubview(endDateView)
        endDateView.anchor(top: weekTextField.bottomAnchor, paddingTop: 20,
                           width: UIScreen.main.bounds.width - 40,
                           height: 40)

        endDateView.addSubview(endTitleLabel)
        endTitleLabel.anchor(leading: endTitleLabel.superview?.leadingAnchor, paddingLeading: 10,
                             centerY: endTitleLabel.superview?.centerYAnchor)

        endDateView.addSubview(endDateLabel)
        endDateLabel.anchor(leading: endTitleLabel.trailingAnchor, paddingLeading: 10,
                            centerY: endDateLabel.superview?.centerYAnchor)

        anchor(bottom: endDateLabel.bottomAnchor)
    }

    func updateEndDate(date: Date) {
        endDateLabel.text = date.toDateWithWeekdayString()
    }

    func update(week: Int) {
        weekTextField.text = "\(week)"
    }

}
