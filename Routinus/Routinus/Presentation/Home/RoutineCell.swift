//
//  RoutineCell.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/02.
//

import UIKit

enum Category {
    case exercise, selfDevelopment, lifeStyle, finance, hobby, etc

    var categoryColor: String {
        switch self {
        case .exercise:
            return "ExerciseColor"
        case .selfDevelopment:
            return "SelfDevelopmentColor"
        case .lifeStyle:
            return "LifeStyleColor"
        case .finance:
            return "FinanceColor"
        case .hobby:
            return "HobbyColor"
        case .etc:
            return "ETCColor"
        }
    }

    var categoryImage: String {
        switch self {
        case .exercise:
            return "dumbbell"
        case .selfDevelopment:
            return "pencil"
        case .lifeStyle:
            return "check.calendar"
        case .finance:
            return "creditcard.and.123"
        case .hobby:
            return "play.circle"
        case .etc:
            return "guitars"
        }
    }
}

class RoutineCell: UITableViewCell {

    static let identifier: String = "RoutineCell"

    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.layer.borderWidth = 5
        progressView.layer.cornerRadius = 25
        progressView.layer.borderColor = UIColor(named: Category.exercise.categoryColor)?.cgColor
        progressView.tintColor = UIColor(named: Category.exercise.categoryColor)

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

    private lazy var categoryName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureViews()
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

        self.contentView.addSubview(categoryName)
        self.categoryName.snp.makeConstraints { make in
            make.leading.equalTo(self.categoryImageView.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }
    }

    func configureCell(routine: Routine) {
        if UIImage(systemName: routine.category.categoryImage) == nil {
            categoryImageView.image = UIImage(named: routine.category.categoryImage)
        } else {
            categoryImageView.image = UIImage(systemName: routine.category.categoryImage)
        }
        categoryName.text = routine.challengeTitle
    }
}
