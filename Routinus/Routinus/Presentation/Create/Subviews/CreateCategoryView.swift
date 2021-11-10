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

    private lazy var button: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.titleLabel?.font = .systemFont(ofSize: 16)
        return button
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
}

extension CreateCategoryView {
    private func configure() {
        configureButton()
        configureLayouts()
    }

    private func configureButton() {
        var configuration = UIButton.Configuration.tinted()
        configuration.title = "운동"
        button.configuration = configuration

        var actions = [UIAction]()
        for category in Challenge.Category.allCases {
            let action = UIAction(title: category.title, image: UIImage(systemName: category.symbol)) { action in
                print(action.title) // TODO: 임시
            }
            actions.append(action)
        }
        button.menu = UIMenu(title: "",
                             image: nil,
                             identifier: nil,
                             options: .displayInline,
                             children: actions)
        button.showsMenuAsPrimaryAction = true
    }

    private func configureLayouts() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.width.equalToSuperview()
            make.height.equalTo(24)
        }

        addSubview(button)
        button.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(40)
        }
    }
}
