//
//  CreateWeekView.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/09.
//

import UIKit

import SnapKit

final class CreateWeekView: UIView {
    typealias Tag = CreateViewController.InputTag

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "챌린지 기간"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "주 단위로 숫자만 입력해주세요. (최대 52주)"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .systemGray
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
        label.text = "주"
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
        label.text = "챌린지 예상 종료일"
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
            self.weekTextField.delegate = delegate
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
        titleLabel.snp.makeConstraints { make in
            make.top.width.equalToSuperview()
            make.height.equalTo(24)
        }

        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.width.equalToSuperview()
        }

        addSubview(weekTextField)
        weekTextField.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.left.equalToSuperview()
            make.width.equalTo(50)
        }

        addSubview(weekLabel)
        weekLabel.snp.makeConstraints { make in
            make.centerY.equalTo(weekTextField.snp.centerY)
            make.left.equalTo(weekTextField.snp.right).offset(10)
        }

        addSubview(endDateView)
        endDateView.snp.makeConstraints { make in
            make.top.equalTo(weekTextField.snp.bottom).offset(20)
            make.width.equalToSuperview()
            make.height.equalTo(40)
        }
        
        endDateView.addSubview(endTitleLabel)
        endTitleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        
        endDateView.addSubview(endDateLabel)
        endDateLabel.snp.makeConstraints { make in
            make.left.equalTo(endTitleLabel.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }
    }

    func updateEndDate(date: Date) {
        endDateLabel.text = date.toExtendedString()
    }
}
