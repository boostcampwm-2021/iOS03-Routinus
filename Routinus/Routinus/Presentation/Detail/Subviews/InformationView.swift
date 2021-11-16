//
//  InformationView.swift
//  Routinus
//
//  Created by 백지현 on 2021/11/16.
//

import UIKit

final class InformationView: UIView {

    private lazy var infomationStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.backgroundColor = .white
        stackView.spacing = 5
        return stackView
    }()

    private lazy var titleStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()

    private lazy var categoryImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: Challenge.Category.exercise.symbol)
        imageView.tintColor = .black
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "1만보 걷기"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()

    private lazy var weekStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()

    private lazy var weekTitleLabel: UILabel = {
        var label = UILabel()
        label.text = "기간"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .darkGray
        return label
    }()

    private lazy var weekView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor(named: "SundayColor")
        return view
    }()

    private lazy var weekLabel: UILabel = {
        var label = UILabel()
        label.text = "4주"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .darkGray
        return label
    }()

    private lazy var endDateStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()

    private lazy var endDateTitleLabel: UILabel = {
        var label = UILabel()
        label.text = "종료일"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .darkGray
        return label
    }()

    private lazy var endDateLabel: UILabel = {
        var label = UILabel()
        label.text = "2021년 11월 7일 일요일"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .right
        label.textColor = .darkGray
        return label
    }()

    private lazy var introductionTitleLabel: UILabel = {
        var label = UILabel()
        label.text = "소개"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .darkGray
        return label
    }()

    private lazy var introductionView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor(named: "LightGrayColor")
        return view
    }()

    private lazy var introductionLabel: UILabel = {
        var label = UILabel()
        label.text = "꾸준히 할 수 있는 운동을 찾으시거나 다이어트 중인데 헬스장은 가기 싫으신분들 함께 1만보씩 걸어요~"
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSubviews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureSubviews()
    }

    convenience init() {
        self.init(frame: CGRect.zero)
    }
}

extension InformationView {
    private func configureSubviews() {
        addSubview(infomationStackView)
        infomationStackView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }

        infomationStackView.addArrangedSubview(titleStackView)
        titleStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }

        titleStackView.addArrangedSubview(categoryImageView)
        categoryImageView.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(20)
        }

        titleStackView.addArrangedSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(20)
        }

        infomationStackView.addArrangedSubview(weekStackView)
        weekStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }

        weekStackView.addArrangedSubview(weekTitleLabel)
        weekTitleLabel.snp.makeConstraints { make in
            make.width.equalTo(40)
            make.height.equalTo(20)
        }

        weekStackView.addArrangedSubview(weekView)
        weekView.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(20)
        }

        weekView.addSubview(weekLabel)
        weekLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }

        infomationStackView.addArrangedSubview(endDateStackView)
        endDateStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }

        endDateStackView.addArrangedSubview(endDateTitleLabel)
        endDateTitleLabel.snp.makeConstraints { make in
            make.width.equalTo(40)
            make.height.equalTo(20)
        }

        endDateStackView.addArrangedSubview(endDateLabel)
        endDateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.width.equalTo(170)
            make.height.equalTo(20)
        }

        infomationStackView.addArrangedSubview(introductionTitleLabel)
        introductionTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(20)
        }

        infomationStackView.addArrangedSubview(introductionView)
        introductionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(5)
            make.height.equalTo(60)
        }

        introductionView.addSubview(introductionLabel)
        introductionLabel.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview().offset(3)
        }
    }
}
