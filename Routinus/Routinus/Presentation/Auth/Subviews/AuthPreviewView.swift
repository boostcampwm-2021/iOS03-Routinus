//
//  AuthPreviewView.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/16.
//

import UIKit

final class AuthPreviewView: UIView {
    weak var delegate: PreviewViewDelegate?

    private lazy var previewView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "LightGray")
        view.layer.cornerRadius = 15
        view.layer.borderColor = UIColor(named: "MainColor")?.cgColor
        view.layer.borderWidth = 2
        view.clipsToBounds = true
        return view
    }()
    private lazy var authButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        button.tintColor = UIColor(named: "SystemForeground")
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 15
        button.isUserInteractionEnabled = false
        return button
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

    func updateImage(_ image: UIImage) {
        let backgroundImage = UIImageView(frame: previewView.bounds)
        backgroundImage.image = image
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.clipsToBounds = true
        previewView.addSubview(backgroundImage)
    }
}

extension AuthPreviewView {
    private func configure() {
        configureSubviews()
        configureGesture()
    }

    private func configureSubviews() {
        addSubview(previewView)
        previewView.anchor(horizontal: self, paddingHorizontal: 20, vertical: self)

        previewView.addSubview(authButton)
        authButton.anchor(centerX: self.centerXAnchor,
                          centerY: self.centerYAnchor,
                          width: 80,
                          height: 80)
    }

    private func configureGesture() {
        let recognizer = UITapGestureRecognizer(target: self,
                                                action: #selector(didTappedPreviewView))
        previewView.isUserInteractionEnabled = true
        previewView.addGestureRecognizer(recognizer)
    }

    @objc private func didTappedPreviewView(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended else { return }
        delegate?.didTappedPreviewView()
    }
}

protocol PreviewViewDelegate: AnyObject {
    func didTappedPreviewView()
}
