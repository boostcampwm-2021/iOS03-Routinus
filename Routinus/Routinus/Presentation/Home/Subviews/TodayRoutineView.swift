//
//  TodayRoutineView.swift
//  Routinus
//
//  Created by 유석환 on 2021/11/07.
//

import UIKit

final class TodayRoutineView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "today routine".localized
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return label
    }()

    let challengePromotionView = ChallengePromotionView()

    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.estimatedRowHeight = 100
        tableView.alwaysBounceVertical = false
        tableView.separatorStyle = .none
        tableView.register(RoutineTableViewCell.self,
                           forCellReuseIdentifier: RoutineTableViewCell.identifier)
        return tableView
    }()

    weak var promotionViewDelegate: ChallengePromotionViewDelegate? {
        didSet {
            challengePromotionView.delegate = promotionViewDelegate
        }
    }

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

        let offset = cellCount == 0 ? challengePromotionView.frame.height + 30 : CGFloat(60 * cellCount)
        anchor(height: 25 + offset)
        challengePromotionView.isHidden = cellCount != 0
    }
}

extension TodayRoutineView {
    private func configure() {
        configureSubviews()
        challengePromotionView.configureChallengePromotionView(
            titleLabel: "add routine".localized,
            buttonLabel: "search challenge".localized
        )
    }

    private func configureSubviews() {
        let smallWidth = UIScreen.main.bounds.width <= 350
        let offset = smallWidth ? 15.0 : 20.0

        addSubview(titleLabel)
        titleLabel.anchor(leading: leadingAnchor,
                          paddingLeading: offset,
                          top: topAnchor)

        addSubview(tableView)
        tableView.anchor(centerX: centerXAnchor,
                         top: titleLabel.bottomAnchor,
                         paddingTop: 10,
                         width: UIScreen.main.bounds.width)
        let constraint = tableView.heightAnchor.constraint(equalToConstant: 60)
        constraint.priority = UILayoutPriority(100)
        constraint.isActive = true

        addSubview(challengePromotionView)
        challengePromotionView.anchor(leading: leadingAnchor,
                                      paddingLeading: 30,
                                      trailing: trailingAnchor,
                                      paddingTrailing: 30,
                                      top: titleLabel.bottomAnchor,
                                      paddingTop: 10)
    }
}
