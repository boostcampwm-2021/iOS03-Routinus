//
//  HomeRoutineTableViewCell.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/02.
//

import UIKit

final class HomeRoutineTableViewCell: UITableViewCell {
    static let identifier: String = "HomeRoutineTableViewCell"

    private lazy var borderView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
        view.layer.borderWidth = 5
        view.clipsToBounds = true
        return view
    }()
    private lazy var achievementRateView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    private lazy var categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(named: "SystemForeground")
        return imageView
    }()
    private lazy var categoryNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    private lazy var leftArrowImageView: UIImageView = {
        let imageConfig = UIImage.SymbolConfiguration(weight: .semibold)
        let image = UIImageView(image: UIImage(systemName: "chevron.left.2",
                                               withConfiguration: imageConfig))
        image.tintColor = UIColor(named: "DayColor")
        image.anchor(width: image.frame.width)
        return image
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }

    func updateCell(routine: TodayRoutine) {
        if UIImage(systemName: routine.category.symbol) == nil {
            categoryImageView.image = UIImage(named: routine.category.symbol)
        } else {
            categoryImageView.image = UIImage(systemName: routine.category.symbol)
        }
        borderView.layer.borderColor = UIColor(named: routine.category.color)?.cgColor
        achievementRateView.backgroundColor = UIColor(named: routine.category.color)?.withAlphaComponent(0.7)
        categoryNameLabel.text = routine.title

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let progress = Float(routine.authCount) / Float(routine.totalCount)
            if progress != 0 {
                self.achievementRateView.isHidden = false
                self.achievementRateView.removeLastAnchor()
                self.achievementRateView.anchor(
                    leading: self.borderView.leadingAnchor,
                    top: self.borderView.topAnchor,
                    bottom: self.borderView.bottomAnchor,
                    width: self.borderView.bounds.width * CGFloat(progress)
                )
            } else {
                self.achievementRateView.isHidden = true
            }
        }
    }
}

extension HomeRoutineTableViewCell {
    private func configureViews() {
        let smallWidth = UIScreen.main.bounds.width <= 350
        let offset = smallWidth ? 15.0 : 20.0

        backgroundColor = UIColor(named: "SystemBackground")

        contentView.addSubview(borderView)
        borderView.anchor(horizontal: borderView.superview,
                          paddingHorizontal: offset,
                          centerY: centerYAnchor,
                          height: contentView.frame.height + 5)

        borderView.addSubview(achievementRateView)
        achievementRateView.anchor(leading: borderView.leadingAnchor,
                                   top: borderView.topAnchor,
                                   bottom: borderView.bottomAnchor,
                                   width: 0)

        contentView.addSubview(leftArrowImageView)
        leftArrowImageView.anchor(trailing: trailingAnchor,
                                  paddingTrailing: 20 + offset,
                                  centerY: centerYAnchor)

        contentView.addSubview(categoryImageView)
        categoryImageView.anchor(leading: leadingAnchor,
                                 paddingLeading: offset + 20,
                                 centerY: centerYAnchor,
                                 width: 30,
                                 height: 30)

        contentView.addSubview(categoryNameLabel)
        categoryNameLabel.anchor(leading: categoryImageView.trailingAnchor,
                                 paddingLeading: 10,
                                 trailing: leftArrowImageView.leadingAnchor,
                                 centerY: centerYAnchor)
    }
}
