//
//  ChallengeCategoryButton.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/08.
//

import UIKit

final class ChallengeCategoryButton: UIView {
    private var imageView = UIImageView()
    private var title = UILabel()

    override init(frame: CGRect) {
        self.imageView = UIImageView()
        self.title = UILabel()
        super.init(frame: frame)
        configureViews()
    }

    required init?(coder aDecoder: NSCoder) {
        self.imageView = UIImageView()
        self.title = UILabel()
        super.init(coder: aDecoder)
        configureViews()
    }

    func setImage(_ image: UIImage?) {
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
    }

    func setTitle(_ text: String) {
        title.text = text
        title.tintColor = UIColor(named: "Black")
    }

    func setTintColor(_ color: UIColor?) {
        imageView.tintColor = color
    }

    private func configureViews() {
        anchor(width: 60, height: 60)

        self.addSubview(imageView)
        imageView.anchor(centerX: imageView.superview?.centerXAnchor,
                         top: imageView.superview?.topAnchor,
                         width: 35, height: 35)

        self.addSubview(title)
        title.anchor(centerX: title.superview?.centerXAnchor,
                     bottom: title.superview?.bottomAnchor)
    }
}

final class ChallengeCategoryButtonTapGesture: UITapGestureRecognizer {
    private (set) var category: Challenge.Category?

    func configureCategory(category: Challenge.Category) {
        self.category = category
    }
}
