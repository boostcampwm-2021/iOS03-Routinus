//
//  TodayRoutineView.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/07.
//

import UIKit

final class TodayRoutineView: UIView {
    weak var challengeAddDelegate: TodayRoutineDelegate?

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

    private(set) lazy var tableView: UITableView = {
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
        removeLastAnchor()
        anchor(height: 25 + CGFloat(60 * cellCount))

        tableView.removeLastAnchor()
        tableView.anchor(height: 60 * CGFloat(cellCount))
        tableView.layoutIfNeeded()
        tableView.reloadData()
    }
}

extension TodayRoutineView {
    @objc func didTappedAddChallengeButton() {
        self.challengeAddDelegate?.didTappedAddChallengeButton()
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
        titleLabel.anchor(left: titleLabel.superview?.leftAnchor, paddingLeft: offset,
                          top: titleLabel.superview?.topAnchor)

        addSubview(addButton)
        addButton.anchor(right: addButton.superview?.rightAnchor, paddingRight: offset,
                         top: addButton.superview?.topAnchor)

        addSubview(tableView)
        tableView.anchor(centerX: tableView.superview?.centerXAnchor,
                         top: titleLabel.bottomAnchor, paddingTop: 10,
                         width: UIScreen.main.bounds.width)
        let constraint = tableView.heightAnchor.constraint(equalToConstant: 60)
        constraint.priority = UILayoutPriority(100)
        constraint.isActive = true
    }
}

protocol TodayRoutineDelegate: AnyObject {
    func didTappedAddChallengeButton()
}
