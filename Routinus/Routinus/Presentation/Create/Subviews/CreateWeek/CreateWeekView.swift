//
//  CreateWeekView.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/09.
//

import UIKit

import SnapKit

final class CreateWeekView: UIView {
    enum WeekTitle: String, CaseIterable {
        case one = "1주"
        case two = "2주"
        case three = "3주"
        case four = "4주"
        case other = "기타"
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "챌린지 기간"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()

    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: WeekTitle.allCases.map { $0.rawValue })
        control.frame = CGRect.zero
        control.addTarget(self, action: #selector(didChangeValue(_:)), for: .valueChanged)
        control.selectedSegmentIndex = 0
        return control
    }()

    private lazy var weekTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "주 단위로 숫자만 입력해주세요."
        textField.isHidden = false
        return textField
    }()

    private lazy var endDateTextField: UITextField = {
        let textField = UITextField()
        textField.text = "챌린지 예상 종료일 1999.01.01(금)"
        return textField
    }()

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

    @objc private func didChangeValue(_ sender: UISegmentedControl) {
        weekTextField.isEnabled = !(sender.selectedSegmentIndex == 4)
    }
}

extension CreateWeekView {
    private func configure() {
        configureSubviews()
    }

    private func configureSubviews() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }

        addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.width.equalToSuperview()
        }

        addSubview(weekTextField)
        weekTextField.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(20)
            make.width.equalToSuperview()
        }

        addSubview(endDateTextField)
        endDateTextField.snp.makeConstraints { make in
            make.top.equalTo(weekTextField.snp.bottom).offset(20)
            make.width.equalToSuperview()
        }
    }
}
