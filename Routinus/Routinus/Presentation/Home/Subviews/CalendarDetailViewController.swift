//
//  CalendarDetailViewController.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/27.
//

import UIKit

class CalendarDetailViewController: UIViewController {
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "YYYY.MM.DD".localized
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "authificated %d challenges".localized
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(named: "DayColor")
        return label
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.estimatedRowHeight = 300
        tableView.alwaysBounceVertical = false
        tableView.separatorStyle = .none
        tableView.register(RoutineTableViewCell.self, forCellReuseIdentifier: RoutineTableViewCell.identifier)
        return tableView
    }()

    private var routines: [TodayRoutine]?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }

    func configureViews() {
        view.addSubview(dateLabel)
        dateLabel.anchor(leading: view.leadingAnchor,
                          paddingLeading: 20,
                          top: view.topAnchor,
                          paddingTop: 20)

        view.addSubview(subtitleLabel)
        subtitleLabel.anchor(leading: dateLabel.leadingAnchor,
                             top: dateLabel.bottomAnchor,
                             paddingTop: 5)

        view.addSubview(tableView)
        tableView.anchor(centerX: view.centerXAnchor,
                         top: subtitleLabel.bottomAnchor,
                         paddingTop: 10,
                         width: UIScreen.main.bounds.width,
                         height: 300)
    }
}

extension CalendarDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 받아오는 데이터 개수
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RoutineTableViewCell.identifier,
                                                       for: indexPath) as? RoutineTableViewCell
            else { return UITableViewCell() }
        cell.configureCell(routine: routines[indexPath.item])
        cell.selectionStyle = .none
        return cell
    }
}
