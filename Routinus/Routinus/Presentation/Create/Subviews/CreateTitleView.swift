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
        label.text = "챌린지 제목을 입력해주세요."
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "타인에게 불쾌감을 주는 단어는 지양해주세요."
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 2
        label.textColor = .systemGray
        return label
    }()

    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "예) 아침 6시에 일어나기"
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
