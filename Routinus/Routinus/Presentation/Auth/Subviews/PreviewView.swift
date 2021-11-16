//
//  PreviewView.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/16.
//

import UIKit

final class PreviewView: UIView {
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.clipsToBounds = true
        return stackView
    }()

    private lazy var previewImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "camera.fill"))
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var previewLabel: UILabel = {
        let label = UILabel()
        label.text = "Preview"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 26)
        return label
    }()

    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "time"
        label.font = UIFont.boldSystemFont(ofSize: 18)
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

extension PreviewView {
    private func configure() {
        configureSubviews()
    }

    private func configureSubviews() {
        self.backgroundColor = UIColor(named: "MainColor")
        self.addSubview(stackView)
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        self.previewImageView.translatesAutoresizingMaskIntoConstraints = false
        self.previewImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        self.previewImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true

        self.previewLabel.translatesAutoresizingMaskIntoConstraints = false
        self.previewLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        [previewImageView, previewLabel].forEach { self.stackView.addArrangedSubview($0) }

        self.addSubview(timeLabel)
        self.timeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.timeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.timeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
    }
}
