//
//  CreateIntroductionView.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/09.
//

import UIKit

final class CreateIntroductionView: UIView {
    typealias Tag = CreateViewController.InputTag

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "챌린지를 소개하세요."
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "챌린지를 자세히 소개해보세요. (최대 150자)"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .systemGray
        label.numberOfLines = 2
        return label
    }()

    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 10
        textView.font = .systemFont(ofSize: 16)
        textView.tag = Tag.introduction.rawValue
        return textView
    }()

    weak var delegate: UITextViewDelegate? {
        didSet {
            self.textView.delegate = delegate
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
        textView.endEditing(true)
    }
}

extension CreateIntroductionView {
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

        addSubview(textView)
        textView.anchor(top: descriptionLabel.bottomAnchor, paddingTop: 20,
                        width: UIScreen.main.bounds.width - 40,
                        height: 150)

        anchor(bottom: textView.bottomAnchor)
    }
}
