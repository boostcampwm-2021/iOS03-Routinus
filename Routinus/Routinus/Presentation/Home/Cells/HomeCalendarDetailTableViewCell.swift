//
//  HomeCalendarDetailTableViewCell.swift
//  Routinus
//
//  Created by 김민서 on 2021/12/01.
//

import UIKit

final class HomeCalendarDetailTableViewCell: UITableViewCell {
    static let identifier: String = "HomeCalendarDetailTableViewCell"

    private lazy var categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(named: "SystemForeground")
        return imageView
    }()

    private lazy var challengeNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureViews()
    }

    func updateCell(challenge: Challenge) {
        if UIImage(systemName: challenge.category.symbol) == nil {
            categoryImageView.image = UIImage(named: challenge.category.symbol)
        } else {
            categoryImageView.image = UIImage(systemName: challenge.category.symbol)
        }
        categoryImageView.tintColor = UIColor(named: challenge.category.color)
        challengeNameLabel.text = challenge.title
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension HomeCalendarDetailTableViewCell {
    private func configureViews() {
        let smallWidth = UIScreen.main.bounds.width <= 350
        let offset = smallWidth ? 15.0 : 20.0

        backgroundColor = UIColor(named: "SystemBackground")

        contentView.addSubview(categoryImageView)
        categoryImageView.anchor(leading: leadingAnchor,
                                 paddingLeading: offset,
                                 centerY: centerYAnchor,
                                 width: 30,
                                 height: 30)

        contentView.addSubview(challengeNameLabel)
        challengeNameLabel.anchor(leading: categoryImageView.trailingAnchor,
                                  paddingLeading: 20,
                                  trailing: contentView.trailingAnchor,
                                  centerY: centerYAnchor)
    }
}
