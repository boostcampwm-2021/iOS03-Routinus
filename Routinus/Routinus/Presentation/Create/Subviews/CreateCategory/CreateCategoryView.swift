//
//  CreateCategoryView.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/09.
//

import UIKit

import SnapKit

final class CreateCategoryView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "어떤 주제와 관련이 있나요?"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()

    private lazy var categoryPickerView = UIPickerView()

    weak var delegate: UIPickerViewDelegate? {
        didSet {
            categoryPickerView.delegate = delegate
        }
    }

    weak var dataSource: UIPickerViewDataSource? {
        didSet {
            categoryPickerView.delegate = delegate
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
}

extension CreateCategoryView {
    private func configure() {
        configureSubviews()
    }

    private func configureSubviews() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.width.equalToSuperview()
        }

        addSubview(categoryPickerView)
        categoryPickerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(-20)
            make.width.equalToSuperview()
        }
    }
}
