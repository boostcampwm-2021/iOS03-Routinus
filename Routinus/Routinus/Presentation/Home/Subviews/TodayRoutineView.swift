//
//  TodayRoutineView.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/07.
//

import UIKit

import SnapKit

final class TodayRoutineView: UIView {
    weak var challengeAdddelegate: TodayRoutineDelegate?

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘 루틴"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()

    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTappedAddChallengeButton), for: .touchUpInside)
        return button
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.estimatedRowHeight = 100
        tableView.alwaysBounceVertical = false
        tableView.separatorStyle = .none
        tableView.register(RoutineTableViewCell.self, forCellReuseIdentifier: RoutineTableViewCell.identifier)
        return tableView
    }()

    weak var delegate: UITableViewDelegate? {
        didSet {
            tableView.delegate = delegate
        }
    }

    weak var dataSource: UITableViewDataSource? {
        didSet {
            tableView.dataSource = dataSource
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    convenience init() {
        self.init(frame: CGRect.zero)
    }

    func updateTableViewConstraints(cellCount: Int) {
        snp.updateConstraints { make in
            make.height.equalTo(25 + 60 * cellCount)
        }
        tableView.snp.updateConstraints { make in
            make.height.equalTo(60 * cellCount)
        }
        tableView.reloadData()
    }
}

extension TodayRoutineView {
    @objc func didTappedAddChallengeButton() {
        self.challengeAdddelegate?.didTappedAddChallengeButton()
    }
}

extension TodayRoutineView {
    private func configure() {
        configureSubviews()
    }

    private func configureSubviews() {
        let smallWidth = UIScreen.main.bounds.width <= 350
        let offset = smallWidth ? 15.0 : 20.0

        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(offset)
            make.top.equalToSuperview()
        }

        addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-offset)
            make.top.equalToSuperview()
        }

        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(60)
        }
    }
}

protocol TodayRoutineDelegate: AnyObject {
    func didTappedAddChallengeButton()
}
