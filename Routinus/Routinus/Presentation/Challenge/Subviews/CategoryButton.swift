//
//  CategoryButton.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/08.
//

import UIKit
import SnapKit

class CategoryButton: UIView {
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
        title.tintColor = .black
    }

    func setTintColor(_ color: UIColor?) {
        imageView.tintColor = color
    }

    private func configureViews() {
        self.snp.makeConstraints { make in
            make.width.height.equalTo(60)
        }

        self.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
            make.width.height.equalTo(35)
        }

        self.addSubview(title)
        title.snp.makeConstraints { make in
            make.bottom.centerX.equalToSuperview()
        }
    }
}

class CategoryButtonTapGesture: UITapGestureRecognizer {
    private (set) var category: Challenge.Category?

    func configureCategory(category: Challenge.Category) {
        self.category = category
    }
}
