//
//  AuthMethodView.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/16.
//

import UIKit

final class AuthMethodView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "인증 방법"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()

    private lazy var methodImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .brown
        return imageView
    }()

    private lazy var methodView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        return view
    }()

    private lazy var methodLabel: UILabel = {
        var label = UILabel()
        label.text = "1만보 이상 걸음 수가 기록된 앱 화면 또는 스마트 워치 사진 올리기"
        label.numberOfLines = 0
        label.textColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
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

extension AuthMethodView {
    private func configure() {
        self.backgroundColor = .white
        configureSubviews()
    }

    private func configureSubviews() {
        self.addSubview(titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true

        self.addSubview(methodImageView)
        self.methodImageView.translatesAutoresizingMaskIntoConstraints = false
        self.methodImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        self.methodImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        self.methodImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        self.methodImageView.heightAnchor.constraint(equalTo: self.methodImageView.widthAnchor, multiplier: 1).isActive = true

        self.addSubview(methodView)
        self.methodView.translatesAutoresizingMaskIntoConstraints = false
        self.methodView.topAnchor.constraint(equalTo: self.methodImageView.bottomAnchor, constant: 15).isActive = true
        self.methodView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        self.methodView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        self.methodView.heightAnchor.constraint(equalToConstant: 60).isActive = true

        methodView.addSubview(methodLabel)
        self.methodLabel.translatesAutoresizingMaskIntoConstraints = false
        self.methodLabel.leadingAnchor.constraint(equalTo: self.methodView.leadingAnchor, constant: 5).isActive = true
        self.methodLabel.trailingAnchor.constraint(equalTo: self.methodView.trailingAnchor, constant: -5).isActive = true
        self.methodLabel.topAnchor.constraint(equalTo: self.methodView.topAnchor, constant: 5).isActive = true
        self.methodLabel.bottomAnchor.constraint(equalTo: self.methodView.bottomAnchor, constant: -5).isActive = true
    }
}
