//
//  CreateTitleView.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/09.
//

import UIKit

final class CreateTitleView: UIView {
    typealias Tag = CreateViewController.InputTag

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "write challenge name".localized
        label.font = .boldSystemFont(ofSize: 20)
        label.numberOfLines = 2
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "don't use bad words".localized
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 2
        label.textColor = .systemGray
        return label
    }()

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "ex) wake up at 6am".localized
        textField.borderStyle = .roundedRect
        textField.tag = Tag.title.rawValue
        return textField
    }()

    weak var delegate: UITextFieldDelegate? {
        didSet {
            self.textField.delegate = delegate
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
        textField.endEditing(true)
    }

    func update(title: String) {
        textField.text = title
    }
}

extension CreateTitleView {
    private func configure() {
        configureSubviews()
    }

    private func configureSubviews() {
        addSubview(titleLabel)
        titleLabel.anchor(top: titleLabel.superview?.topAnchor,
                          width: UIScreen.main.bounds.width - 40)

        addSubview(descriptionLabel)
        descriptionLabel.anchor(top: titleLabel.bottomAnchor, paddingTop: 10,
                                width: UIScreen.main.bounds.width - 40)

        addSubview(textField)
        textField.anchor(top: descriptionLabel.bottomAnchor, paddingTop: 20,
                         width: UIScreen.main.bounds.width - 40)

        anchor(bottom: textField.bottomAnchor)
    }
}
