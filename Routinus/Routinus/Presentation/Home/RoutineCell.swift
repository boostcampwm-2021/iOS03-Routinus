//
//  RoutineCell.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/02.
//

import UIKit

class RoutineCell: UITableViewCell {

    static let identifier: String = "RoutineCell"

    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.layer.borderWidth = 5
        progressView.layer.cornerRadius = 30
        progressView.layer.borderColor = UIColor.systemOrange.cgColor
        progressView.tintColor = UIColor.systemOrange

        progressView.progress = 0.5
        progressView.clipsToBounds = true
        progressView.progressViewStyle = .bar

        progressView.layer.sublayers![1].cornerRadius = 30
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

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureViews()
    }
}

extension RoutineCell {
    private func configureViews() {
        self.backgroundColor = .white

        self.addSubview(progressView)
        self.progressView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
        }

        self.addSubview(categoryImageView)
        self.categoryImageView.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }

        self.addSubview(categoryName)
        self.categoryName.snp.makeConstraints { make in
            make.leading.equalTo(self.categoryImageView.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
        }
    }

    func configureCell(routine: Routine) {
        categoryImageView.image = UIImage(systemName: routine.categoryImage)
        categoryName.text = routine.categoryText
    }
}
