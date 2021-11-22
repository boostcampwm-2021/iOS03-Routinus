//
//  ProfileView.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/22.
//

import UIKit

final class ProfileView: UIView {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "seed")
        return imageView
    }()

    private lazy var nameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()

    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "username"
        return label
    }()

    private lazy var updateButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("수정", for: .normal)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }
}

extension ProfileView {
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
        self.nameStackView.addArrangedSubview(updateButton)
    }
}
