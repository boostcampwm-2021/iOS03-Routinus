//
//  RoutineCell.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/02.
//

import UIKit

final class RoutineCell: UITableViewCell {
    static let identifier: String = "RoutineCell"

    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.layer.borderWidth = 5
        progressView.layer.cornerRadius = 25

        progressView.progress = 0.5
        progressView.clipsToBounds = true
        progressView.progressViewStyle = .bar

        progressView.layer.sublayers![1].cornerRadius = 25
        progressView.subviews[1].clipsToBounds = true
        return progressView
    }()

    private lazy var categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var categoryNameLabel: UILabel = {
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
        progressView.progress = Float(routine.authCount) / Float(routine.totalCount)
        progressView.tintColor = UIColor(named: routine.category.color)
        progressView.layer.borderColor = UIColor(named: routine.category.color)?.cgColor
    }
}

extension RoutineCell {
    private func configureViews() {
        self.backgroundColor = .white

        self.contentView.addSubview(progressView)
        self.progressView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }

        self.contentView.addSubview(categoryImageView)
        self.categoryImageView.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }

        self.contentView.addSubview(categoryNameLabel)
        self.categoryNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.categoryImageView.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }
    }
}
