//
//  PreviewView.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/16.
//

import UIKit

final class PreviewView: UIView {
    weak var delegate: PreviewViewDelegate?

    private lazy var preview: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "MainColor")

        return view
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.clipsToBounds = true
        return stackView
    }()

    private lazy var authButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        button.tintColor = .black
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 15
        button.isUserInteractionEnabled = false
        return button
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

    @objc func didTappedAuthButton() {
        self.delegate?.didTappedAuthButton()
    }

    func setImage(_ image: UIImage) {
        let backgroundImage = UIImageView(frame: self.bounds)
        backgroundImage.image = image
        backgroundImage.contentMode = .scaleToFill
        self.insertSubview(backgroundImage, at: 0)
    }
}

extension PreviewView {
    private func configure() {
        configureSubviews()
    }

    private func configureSubviews() {
        self.addSubview(preview)
        self.preview.translatesAutoresizingMaskIntoConstraints = false
        self.preview.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.preview.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.preview.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        self.preview.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        
        preview.addSubview(stackView)
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true

        self.authButton.translatesAutoresizingMaskIntoConstraints = false
        self.authButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        self.authButton.heightAnchor.constraint(equalToConstant: 80).isActive = true

        self.previewLabel.translatesAutoresizingMaskIntoConstraints = false
        self.previewLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        [authButton, previewLabel].forEach { self.stackView.addArrangedSubview($0) }

        preview.addSubview(timeLabel)
        self.timeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.timeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.timeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
    }
}

protocol PreviewViewDelegate: AnyObject {
    func didTappedAuthButton()
}
