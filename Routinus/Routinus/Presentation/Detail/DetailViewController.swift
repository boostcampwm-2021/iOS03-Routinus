//
//  DetailViewController.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/02.
//

import UIKit

final class DetailViewController: UIViewController {

    private lazy var scrollView: UIScrollView = UIScrollView()
    private lazy var stackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 50
        stackView.distribution = .fillProportionally
        stackView.backgroundColor = UIColor(named: "LightGrayColor")
        return stackView
    }()

    // 0
    private lazy var mainImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "walk")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    // 1
    private lazy var infomationStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.backgroundColor = .white
        stackView.spacing = 5
        return stackView
    }()

    // 1-1
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

    // 1-2
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

    // 1-3
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

    // 1-4 소개
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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.configureViews()
    }

    func configureViews() {
        self.view.backgroundColor = .white
        self.configureNavigationBar()

        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
            make.centerX.equalToSuperview()
        }

        // 0. 메인 이미지
        stackView.addArrangedSubview(mainImageView)
        mainImageView.snp.makeConstraints { make in
            make.height.equalTo(200)
        }

        // 1. 상세 정보 스택
        stackView.addArrangedSubview(infomationStackView)
        infomationStackView.snp.makeConstraints { make in
            make.height.equalTo(180)
        }

        // 1-1. 타이틀 스택
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

        // 1-2. 기간 스택
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

        // 1-3. 종료일 스택
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

        // 1-4 소개
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

    private func configureNavigationBar() {
        self.navigationItem.largeTitleDisplayMode = .never
        // TODO: 챌린지 연동
        // TODO: 작성자인 경우에만 rightBarButtonItem 보이기
        self.navigationItem.title = "1만보 걷기"
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: nil)
        rightBarButtonItem.tintColor = .black
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }

    @objc func didTouchbackButton() {
        let transition = CATransition()
        transition.duration = 0.35
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false)
    }

    @objc func didTouchAuthButton() {
        let authViewController = AuthViewController()
        self.present(authViewController, animated: true, completion: nil)
    }
}
