//
//  MyPageProfileView.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/22.
//

import UIKit

final class MyPageProfileView: UIView {
    weak var delegate: MyPageUserNameUpdatableDelegate?

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private lazy var recognizer = UITapGestureRecognizer(target: self,
                                                         action: #selector(didTapNameStackView))
    private lazy var nameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.addGestureRecognizer(recognizer)
        return stackView
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "username"
        return label
    }()
    private lazy var updateIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "pencil")
        imageView.tintColor = UIColor(named: "SystemForeground")
        return imageView
    }()

    var name: String? {
        return nameLabel.text
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    func updateName(_ name: String) {
        nameLabel.text = name
    }

    func updateImage(with user: User) {
        imageView.image = UIImage(named: ContinuityState.image(for: user.continuityDay))
    }
}

extension MyPageProfileView {
    private func configure() {
        configureViews()
    }

    private func configureViews() {
        addSubview(imageView)
        imageView.anchor(centerX: centerXAnchor,
                         top: topAnchor,
                         paddingTop: 10,
                         width: 120,
                         height: 120)

        addSubview(nameStackView)
        nameStackView.anchor(centerX: centerXAnchor,
                             top: imageView.bottomAnchor,
                             paddingTop: 20)

        nameStackView.addArrangedSubview(nameLabel)
        nameStackView.addArrangedSubview(updateIconImageView)
    }

    @objc private func didTapNameStackView() {
        delegate?.didTappedNameStackView()
    }
}
