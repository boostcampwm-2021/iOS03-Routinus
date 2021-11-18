//
//  CreateCategoryView.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/09.
//

import UIKit

final class CreateCategoryView: UIView {
    weak var delegate: CreateSubviewDelegate?
    
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
            let image = UIImage(systemName: category.symbol) == nil ? UIImage(named: category.symbol) : UIImage(systemName: category.symbol)
            let action = UIAction(title: category.title, image: image) { [weak self] action in
                guard let self = self else { return }
                self.delegate?.didChange(category: category)
                self.button.configuration?.title = category.title
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
        titleLabel.anchor(top: titleLabel.superview?.topAnchor,
                          width: UIScreen.main.bounds.width - 20)

        addSubview(button)
        button.anchor(left: button.superview?.leftAnchor,
                      top: titleLabel.bottomAnchor, paddingTop: 20,
                      width: 100, height: 40)

        anchor(bottom: button.bottomAnchor)
    }
}
