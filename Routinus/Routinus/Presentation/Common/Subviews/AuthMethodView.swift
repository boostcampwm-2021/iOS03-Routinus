//
//  AuthMethodView.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/16.
//

import UIKit

final class AuthMethodView: UIView {
    weak var delegate: AuthMethodViewDelegate?

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "auth method".localized
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()

    private lazy var methodImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemBackground
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    private lazy var methodView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = .systemGray6
        return view
    }()

    private lazy var methodLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor(named: "Black")
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
        backgroundColor = .systemBackground
        configureSubviews()
        configureMethodViewTapGesture()
    }

    private func configureSubviews() {
        addSubview(titleLabel)
        titleLabel.anchor(leading: leadingAnchor,
                          paddingLeading: 20,
                          top: topAnchor,
                          paddingTop: 20)

        addSubview(methodImageView)
        methodImageView.anchor(leading: leadingAnchor,
                               paddingLeading: 20,
                               top: titleLabel.bottomAnchor,
                               paddingTop: 10,
                               width: 150,
                               height: 150)

        addSubview(methodView)
        methodView.anchor(horizontal: self,
                          paddingHorizontal: 20,
                          top: methodImageView.bottomAnchor,
                          paddingTop: 15,
                          bottom: bottomAnchor,
                          paddingBottom: 20)

        methodView.addSubview(methodLabel)
        methodLabel.anchor(horizontal: methodView,
                           paddingHorizontal: 10,
                           vertical: methodView,
                           paddingVertical: 10)
    }

    private func configureMethodViewTapGesture() {
        let singleTapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(tappedMethodImageView)
        )
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        methodImageView.addGestureRecognizer(singleTapGestureRecognizer)
    }

    @objc func tappedMethodImageView() {
        delegate?.didTappedAuthMethodImageView()
    }

    func update(to text: String) {
        methodLabel.text = text
    }

    func update(to data: Data) {
        methodImageView.image = UIImage(data: data)
    }

    var authThumbnailImage: Data? {
        return methodImageView.image?.jpegData(compressionQuality: 1)
    }
}

protocol AuthMethodViewDelegate: AnyObject {
    func didTappedAuthMethodImageView()
}
