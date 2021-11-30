//
//  ChallengeCategoryIconView.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/08.
//

import UIKit

final class ChallengeCategoryIconView: UIView {
    private var imageView = UIImageView()
    private var title = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView()
        title = UILabel()
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        imageView = UIImageView()
        title = UILabel()
        configure()
    }

    func updateImage(_ image: UIImage?) {
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
    }

    func updateTitle(_ text: String) {
        title.text = text
        title.tintColor = UIColor(named: "Black")
    }

    func updateTintColor(_ color: UIColor?) {
        imageView.tintColor = color
    }
}

extension ChallengeCategoryIconView {
    private func configure() {
        configureViews()
    }

    private func configureViews() {
        anchor(width: 60, height: 60)

        addSubview(imageView)
        imageView.anchor(centerX: imageView.superview?.centerXAnchor,
                         top: imageView.superview?.topAnchor,
                         width: 35,
                         height: 35)

        addSubview(title)
        title.anchor(centerX: title.superview?.centerXAnchor,
                     bottom: title.superview?.bottomAnchor)
    }
}

final class ChallengeCategoryIconViewTapGesture: UITapGestureRecognizer {
    private(set) var category: Challenge.Category?

    func configureCategory(category: Challenge.Category) {
        self.category = category
    }
}
