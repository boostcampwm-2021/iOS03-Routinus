//
//  FormImageRegisterView.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/09.
//

import UIKit

final class FormImageRegisterView: UIView {
    weak var delegate: FormImagePickerDelegate?

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "upload challenge main image".localized
        label.font = .boldSystemFont(ofSize: 20)
        label.numberOfLines = 2
        return label
    }()
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "camera")
        imageView.tintColor = UIColor(named: "SystemForeground")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor(named: "DayColor")?.cgColor
        return imageView
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
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
    }
}

extension FormImageRegisterView {
    private func configure() {
        configureSubviews()
        configureGesture()
    }

    private func configureSubviews() {
        addSubview(titleLabel)
        titleLabel.anchor(top: titleLabel.superview?.topAnchor,
                          width: UIScreen.main.bounds.width - 40)

        addSubview(imageView)
        imageView.anchor(centerX: imageView.superview?.centerXAnchor,
                         top: titleLabel.bottomAnchor, paddingTop: 30,
                         width: 150, height: 150)

        anchor(bottom: imageView.bottomAnchor)
    }

    private func configureGesture() {
        let recognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(didTappedImageView(_:))
        )
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(recognizer)
    }

    @objc private func didTappedImageView(_ sender: UITapGestureRecognizer) {
        guard sender.state == .ended else { return }
        delegate?.didTappedImageView(FormViewController.InputTag.image.rawValue)
    }
}
