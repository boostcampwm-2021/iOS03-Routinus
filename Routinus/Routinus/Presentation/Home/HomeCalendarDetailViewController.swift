//
//  CalendarDetailViewController.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/27.
//

import UIKit

class HomeCalendarDetailViewController: UIViewController, UITableViewDelegate {
    private lazy var bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "SystemBackground")
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()

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
        tableView.register(HomeRoutineTableViewCell.self, forCellReuseIdentifier: HomeRoutineTableViewCell.identifier)
        return tableView
    }()

    var date: String?
    var challenges: [Challenge]? {
        didSet {
            guard let count = challenges?.count else { return }
            subtitleLabel.text = "authificated %d challenges".localized(with: count)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureDelegate()
        configureDimmedViewTapGesture()
    }

    func configureViews() {
        view.backgroundColor = UIColor(named: "Black")?.withAlphaComponent(0.7)
        
        view.addSubview(bottomSheetView)
        bottomSheetView.anchor(horizontal: view,
                               bottom: view.bottomAnchor,
                               height: 400)

        bottomSheetView.addSubview(dateLabel)
        dateLabel.anchor(leading: bottomSheetView.leadingAnchor,
                         paddingLeading: 20,
                         top: bottomSheetView.topAnchor,
                         paddingTop: 20)

        bottomSheetView.addSubview(subtitleLabel)
        subtitleLabel.anchor(leading: dateLabel.leadingAnchor,
                             top: dateLabel.bottomAnchor,
                             paddingTop: 5)

        bottomSheetView.addSubview(tableView)
        tableView.anchor(centerX: bottomSheetView.centerXAnchor,
                         top: subtitleLabel.bottomAnchor,
                         paddingTop: 10,
                         bottom: bottomSheetView.bottomAnchor,
                         width: UIScreen.main.bounds.width)
    }

    func configureDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func configureDimmedViewTapGesture() {
        let singleTapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(tappedBackground)
        )
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(singleTapGestureRecognizer)
    }

    @objc func tappedBackground() {
        dismiss(animated: true)
    }
}

extension HomeCalendarDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let challenges = challenges else { return 0 }
        return challenges.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.textLabel?.text = challenges?[indexPath.item].title
        return cell
    }
}
