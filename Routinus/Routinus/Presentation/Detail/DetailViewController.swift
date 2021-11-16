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
        stackView.spacing = 5
        stackView.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        return stackView
    }()

    private lazy var mainImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "walk")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var informationView = InformationView()

    private lazy var authStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.backgroundColor = .white
        return stackView
    }()

    private lazy var authTitleLabel: UILabel = {
        var label = UILabel()
        label.text = "인증 방법"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()

    private lazy var authImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "walk")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var authMethodView: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        return view
    }()

    private lazy var authMethodLabel: UILabel = {
        var label = UILabel()
        label.text = "[1만보] 이상 걸음 수가 기록된 [앱 화면] 또는 [스마트 워치] 사진 올리기"
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()

    private lazy var challengeButton: UIButton = {
        var button = UIButton()
        button.setTitle("참여하기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        button.backgroundColor = UIColor(red: 180/255, green: 231/255, blue: 160/255, alpha: 1)
        button.layer.cornerRadius = 20
        //button.addTarget(self, action: #selector(), for: .touchUpInside)
        return button
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
            make.top.bottom.leading.trailing.equalToSuperview()
            make.centerX.equalToSuperview()
        }

        // 0. 메인 이미지
        stackView.addArrangedSubview(mainImageView)
        mainImageView.snp.makeConstraints { make in
            make.height.equalTo(300)
        }

        // 1. 상세 정보 스택
        stackView.addArrangedSubview(informationView)
        informationView.snp.makeConstraints { make in
            make.height.equalTo(250)
        }

        // 2. 인증 방법 스택
        stackView.addArrangedSubview(authStackView)
        authStackView.snp.makeConstraints { make in
            make.height.equalTo(200)
        }

        authStackView.addArrangedSubview(authTitleLabel)
        authTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }

        authStackView.addArrangedSubview(authImageView)
        authImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(80)
            make.height.equalTo(80)
        }

        authStackView.addArrangedSubview(authMethodView)
        authMethodView.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(5)
        }

        authMethodView.addSubview(authMethodLabel)
        authMethodLabel.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview().offset(3)
        }

        stackView.addArrangedSubview(challengeButton)
        challengeButton.snp.makeConstraints { make in
            make.height.equalTo(60)
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
