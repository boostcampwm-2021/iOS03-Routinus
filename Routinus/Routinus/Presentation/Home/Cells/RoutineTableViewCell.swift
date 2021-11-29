//
//  RoutineTableViewCell.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/02.
//

import UIKit

final class RoutineTableViewCell: UITableViewCell {
    static let identifier: String = "RoutineTableViewCell"

    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.layer.borderWidth = 5
        progressView.layer.cornerRadius = 25
        progressView.progress = 0.0
        progressView.clipsToBounds = true
        progressView.trackTintColor = .systemBackground
        progressView.tintColor = UIColor(named: "MainColor")
        progressView.layer.borderColor = UIColor(named: "MainColor")?.cgColor
        return progressView
    }()

    private lazy var categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(named: "Black")
        return imageView
    }()

    private lazy var categoryNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()

    private lazy var leftArrow: UIImageView = {
        let imageConfig = UIImage.SymbolConfiguration(weight: .semibold)
        let image = UIImageView(image: UIImage(systemName: "chevron.left.2", withConfiguration: imageConfig))
        image.tintColor = UIColor(named: "DayColor")
        image.anchor(width: image.frame.width)
        return image
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configureCell(routine: TodayRoutine) {
        if UIImage(systemName: routine.category.symbol) == nil {
            categoryImageView.image = UIImage(named: routine.category.symbol)
        } else {
            categoryImageView.image = UIImage(systemName: routine.category.symbol)
        }
        categoryNameLabel.text = routine.title
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1.5, delay: 3) {
                let progress = Float(routine.authCount) / Float(routine.totalCount)
                self.progressView.setProgress(progress, animated: true)
            }
        }
    }
}

extension RoutineTableViewCell {
    private func configureViews() {
        let smallWidth = UIScreen.main.bounds.width <= 350
        let offset = smallWidth ? 15.0 : 20.0

        self.backgroundColor = .systemBackground

        self.contentView.addSubview(progressView)
        progressView.anchor(horizontal: progressView.superview,
                            paddingHorizontal: offset,
                            centerY: centerYAnchor,
                            height: contentView.frame.height + 5)

        self.contentView.addSubview(leftArrow)
        leftArrow.anchor(trailing: trailingAnchor,
                         paddingTrailing: 20 + offset,
                         centerY: centerYAnchor)

        self.contentView.addSubview(categoryImageView)
        categoryImageView.anchor(leading: leadingAnchor,
                                 paddingLeading: offset + 20,
                                 centerY: centerYAnchor,
                                 width: 30, height: 30)

        self.contentView.addSubview(categoryNameLabel)
        categoryNameLabel.anchor(leading: categoryImageView.trailingAnchor,
                                 paddingLeading: 10,
                                 trailing: leftArrow.leadingAnchor,
                                 centerY: centerYAnchor)

    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            progressView.layer.borderColor = UIColor(named: "MainColor")?.cgColor
        }
    }
}
