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

    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)

        tableView.backgroundColor = .yellow

        tableView.estimatedRowHeight = 100
        return tableView
    }()

    let dummyList: [Routine] = [
        Routine(categoryImage: "pencil", categoryText: "물마시기"),
        Routine(categoryImage: "pencil", categoryText: "30분 이상 물 마시기")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.


        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(RoutineCell.self, forCellReuseIdentifier: RoutineCell.identifier)

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
            make.leading.trailing.equalToSuperview()
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

        self.contentView.addSubview(tableView)
        self.tableView.snp.makeConstraints { make in
            make.top.equalTo(todayRoutineTitle.snp.bottom).offset(10)
            make.width.height.equalTo(300)

        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RoutineCell.identifier, for: indexPath) as? RoutineCell else { return UITableViewCell() }
        cell.configureCell(routine: dummyList[indexPath.row])
        return cell
    }
}


struct Routine {
    let categoryImage: String
    let categoryText: String
}
