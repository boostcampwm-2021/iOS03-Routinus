//
//  HomeViewController.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/01.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {

    private let scrollView: UIScrollView = UIScrollView()
    private let contentView: UIView = UIView()

    private lazy var continuityView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 5

        return view
    }()

    private lazy var seedImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    private lazy var continuityDayLabel: UILabel = {
        let label = UILabel()

        label.text = "0"
        label.font = UIFont.boldSystemFont(ofSize: 48)
        return label
    }()

    private lazy var continuityInfoLabel: UILabel = {
        let label = UILabel()

        label.text = "일 연속 달성"
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        return label
    }()

    private lazy var todayRoutineView: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var todayRoutineTitle: UILabel = {
        let label = UILabel()
        label.text = "오늘 루틴"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()

    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .black
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        configureViews()
    }

}

extension HomeViewController {
    func configureViews() {
        self.view.backgroundColor = .white

        self.view.addSubview(scrollView)
        self.scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }

        self.scrollView.addSubview(contentView)
        self.contentView.snp.makeConstraints { make in
            make.centerX.width.top.bottom.equalToSuperview()
        }

        self.contentView.addSubview(continuityView)
        self.continuityView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)

            make.top.equalToSuperview()
            make.height.equalTo(80)
        }

        self.continuityView.addSubview(seedImage)
        self.seedImage.snp.makeConstraints { make in
            make.width.height.equalTo(60)
            make.leading.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }

        self.continuityView.addSubview(continuityDayLabel)
        self.continuityDayLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.seedImage.snp.trailing).offset(20)
            make.centerY.equalToSuperview()
        }

        self.continuityView.addSubview(continuityInfoLabel)
        self.continuityInfoLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.continuityDayLabel.snp.trailing).offset(5)
            make.lastBaseline.equalTo(self.continuityDayLabel.snp.lastBaseline).offset(-2)
        }

        self.contentView.addSubview(todayRoutineView)
        self.todayRoutineView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(self.continuityView.snp.bottom).offset(25)
        }

        self.todayRoutineView.addSubview(todayRoutineTitle)
        self.todayRoutineTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview()
        }

        self.todayRoutineView.addSubview(addButton)
        self.addButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalToSuperview()
        }
    }
}
