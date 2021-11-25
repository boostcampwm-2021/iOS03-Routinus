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
        label.text = "today routine".localized
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return label
    }()

    private lazy var challengeSearchButton: UIButton = {
        let button = UIButton()
        button.setTitle("챌린지 둘러보기", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = UIColor(named: "MainColor")
        button.layer.cornerRadius = 15
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

    private lazy var addRoutineLabel: UILabel = {
        let label = UILabel()
        label.text = "add routine".localized
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
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
        tableView.removeLastAnchor()
        tableView.anchor(height: 60 * CGFloat(cellCount))
        tableView.layoutIfNeeded()

        let offset = cellCount == 0 ? addRoutineLabel.frame.height + challengeSearchButton.frame.height + 30 : CGFloat(60 * cellCount)
        anchor(height: 25 + offset)
        addRoutineLabel.isHidden = cellCount != 0
        challengeSearchButton.isHidden = cellCount != 0
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
        titleLabel.anchor(leading: leadingAnchor, paddingLeading: offset,
                          top: topAnchor)

        addSubview(tableView)
        tableView.anchor(centerX: centerXAnchor,
                         top: titleLabel.bottomAnchor, paddingTop: 10,
                         width: UIScreen.main.bounds.width)
        let constraint = tableView.heightAnchor.constraint(equalToConstant: 60)
        constraint.priority = UILayoutPriority(100)
        constraint.isActive = true

        addSubview(addRoutineLabel)
        addRoutineLabel.anchor(leading: self.leadingAnchor, paddingLeading: 20,
                               top: titleLabel.bottomAnchor, paddingTop: 15)

        addSubview(challengeSearchButton)
        challengeSearchButton.anchor(trailing: self.trailingAnchor, paddingTrailing: 20,
                                     top: addRoutineLabel.bottomAnchor, paddingTop: 10)
    }
}

protocol TodayRoutineDelegate: AnyObject {
    func didTappedAddChallengeButton()
}
