//
//  FormCategoryView.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/09.
//

import UIKit

final class FormCategoryView: UIView {
    weak var delegate: FormSubviewDelegate?

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "what category?".localized
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    private lazy var button: UIButton = {
        let button = UIButton()
        button.tintColor = UIColor(named: "SystemForeground")
        button.titleLabel?.font = .systemFont(ofSize: 16)
        return button
    }()
    var categoryAction: UIAlertController {
        let alert = UIAlertController(title: "category".localized,
                                      message: nil,
                                      preferredStyle: .actionSheet)

        for category in Challenge.Category.allCases {
            let action = UIAlertAction(title: category.title,
                                       style: .default) { [weak self] _ in
                guard let self = self else { return }
                self.delegate?.didChange(category: category)
                self.button.setTitle(category.title, for: .normal)
            }
            alert.addAction(action)
        }

        let cancel = UIAlertAction(title: "cancel".localized, style: .cancel, handler: nil)
        alert.addAction(cancel)

        let height = NSLayoutConstraint(item: alert.view as Any,
                                        attribute: NSLayoutConstraint.Attribute.height,
                                        relatedBy: NSLayoutConstraint.Relation.equal,
                                        toItem: nil,
                                        attribute: NSLayoutConstraint.Attribute.notAnAttribute,
                                        multiplier: 1,
                                        constant: UIScreen.main.bounds.height * 0.6)
        alert.view.addConstraint(height)
        return alert
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

    func update(category: Challenge.Category) {
        button.setTitle(category.title, for: .normal)
    }
}

extension FormCategoryView {
    private func configure() {
        configureButton()
        configureLayouts()
    }

    private func configureButton() {
        if #available(iOS 15.0, *) {
            var configuration = UIButton.Configuration.tinted()
            configuration.title = "exercise".localized
            button.configuration = configuration
        } else {
            button.backgroundColor = UIColor(named: "LightGray")
            button.setTitle("exercise".localized, for: .normal)
            button.setTitleColor(UIColor(named: "SystemForeground"), for: .normal)
            button.layer.cornerRadius = 5
        }

        var actions = [UIAction]()
        for category in Challenge.Category.allCases {
            let image = UIImage(systemName: category.symbol) == nil
                        ? UIImage(named: category.symbol)
                        : UIImage(systemName: category.symbol)
            let action = UIAction(title: category.title, image: image) { [weak self] _ in
                guard let self = self else { return }
                self.delegate?.didChange(category: category)
                self.button.setTitle(category.title, for: .normal)
            }
            actions.append(action)
        }

        if #available(iOS 14.0, *) {
            button.menu = UIMenu(title: "",
                                 image: nil,
                                 identifier: nil,
                                 options: .displayInline,
                                 children: actions)
            button.showsMenuAsPrimaryAction = true
        } else {
            button.addTarget(self, action: #selector(didTappedCategoryButton), for: .touchUpInside)
        }
    }

    private func configureLayouts() {
        addSubview(titleLabel)
        titleLabel.anchor(top: titleLabel.superview?.topAnchor,
                          width: UIScreen.main.bounds.width - 20)

        addSubview(button)
        button.anchor(leading: button.superview?.leadingAnchor,
                      top: titleLabel.bottomAnchor, paddingTop: 20,
                      width: 100, height: 40)

        anchor(bottom: button.bottomAnchor)
    }

    @objc func didTappedCategoryButton(_ sender: UIButton) {
        delegate?.didTappedCategoryButton()
    }
}
