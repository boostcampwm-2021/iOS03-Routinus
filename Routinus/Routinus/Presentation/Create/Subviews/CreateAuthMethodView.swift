//
//  CreateAuthMethodView.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/09.
//

import UIKit

import SnapKit

final class CreateAuthMethodView: UIView {
    typealias Tag = CreateViewController.InputTag
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "인증 방법을 입력해주세요."
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "실천여부를 알 수 있도록 구체적인 인증방법을 적어주세요. (최대 150자)"
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
        textView.tag = Tag.authMethod.rawValue
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

extension CreateAuthMethodView {
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
        
        addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.width.equalToSuperview()
            make.height.equalTo(150)
        }
    }
}
