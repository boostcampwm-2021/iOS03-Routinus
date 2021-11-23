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
        imageView.image = UIImage(named: "seed")
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
        imageView.tintColor = UIColor(named: "Black")
        return imageView
    }()

    var name: String? {
        return nameLabel.text
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }

    @objc private func didTapNameStackView() {
        delegate?.didTappedNameStackView()
    }

    func setName(_ name: String) {
        self.nameLabel.text = name
    }
}

extension MyPageProfileView {
    private func configureViews() {
        self.addSubview(imageView)
        imageView.anchor(centerX: self.centerXAnchor,
                         top: self.topAnchor,
                         paddingTop: 10,
                         width: 120,
                         height: 120)

        self.addSubview(nameStackView)
        nameStackView.anchor(centerX: self.centerXAnchor,
                             top: self.imageView.bottomAnchor,
                             paddingTop: 20)

        self.nameStackView.addArrangedSubview(nameLabel)
        self.nameStackView.addArrangedSubview(updateIconImageView)
    }
}
