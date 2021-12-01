//
//  CalendarDetailViewController.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/27.
//

import UIKit

class HomeCalendarDetailViewController: UIViewController {
    private lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "Black")?.withAlphaComponent(0.7)
        return view
    }()

    private lazy var bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "SystemBackground")
        view.layer.cornerRadius = 15
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()

    private lazy var dragIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "White")
        view.layer.cornerRadius = 3
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
        tableView.register(HomeRoutineTableViewCell.self, forCellReuseIdentifier: HomeRoutineTableViewCell.identifier)
        return tableView
    }()

    private lazy var bottomSheetPanStartingTopConstant: CGFloat = bottomSheetPanMinTopConstant

    private var bottomSheetViewTopConstraint: NSLayoutConstraint?
    private var bottomSheetPanMinTopConstant: CGFloat = 30.0

    var date: Date? {
        didSet {
            dateLabel.text = date?.toDateWithWeekdayString()
        }
    }
    var challenges: [Challenge]? {
        didSet {
            guard let count = challenges?.count else { return }
            subtitleLabel.text = "authificated %d challenges".localized(with: count)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showBottomSheet()
    }
}

extension HomeCalendarDetailViewController {
    private func configure() {
        configureViews()
        configureDelegate()
        configureGesture()
    }

    private func configureViews() {
        view.addSubview(dimmedView)
        dimmedView.anchor(edges: view)
        dimmedView.alpha = 0

        dimmedView.addSubview(bottomSheetView)
        let topConstant = view.safeAreaInsets.bottom + view.safeAreaLayoutGuide.layoutFrame.height
        bottomSheetViewTopConstraint = bottomSheetView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: topConstant
        )

        guard let bottomSheetViewTopConstraint = bottomSheetViewTopConstraint else { return }
        bottomSheetView.anchor(horizontal: view, bottom: view.bottomAnchor)
        NSLayoutConstraint.activate([ bottomSheetViewTopConstraint ])

        view.addSubview(dragIndicatorView)
        dragIndicatorView.anchor(centerX: view.centerXAnchor,
                                 bottom: bottomSheetView.topAnchor,
                                 paddingBottom: 10,
                                 width: 60,
                                 height: dragIndicatorView.layer.cornerRadius * 2)

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
                         paddingTop: 20,
                         bottom: bottomSheetView.bottomAnchor,
                         width: UIScreen.main.bounds.width)

    }

    private func configureDelegate() {
        tableView.dataSource = self
    }

    private func configureGesture() {
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        viewPan.delaysTouchesBegan = false
        viewPan.delaysTouchesEnded = false
        view.addGestureRecognizer(viewPan)
    }

    @objc private func viewPanned(_ panGestureRecognizer: UIPanGestureRecognizer) {
        let translation = panGestureRecognizer.translation(in: self.view)

        switch panGestureRecognizer.state {
        case .began:
            bottomSheetPanStartingTopConstant = bottomSheetViewTopConstraint?.constant ?? 0
        case .changed:
            if translation.y > 0 {
                bottomSheetViewTopConstraint?.constant = bottomSheetPanStartingTopConstant + translation.y
            }
        case .ended:
            if translation.y > 0 {
                hideBottomSheet()
            }
        default:
            break
        }
    }

    @objc func tappedBackground() {
        hideBottomSheet()
    }

    private func showBottomSheet() {
        let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding: CGFloat = view.safeAreaInsets.bottom

        bottomSheetViewTopConstraint?.constant = (safeAreaHeight + bottomPadding) - 400
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedView.alpha = 1
            self.view.layoutIfNeeded()
        })
    }

    private func hideBottomSheet() {
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding = view.safeAreaInsets.bottom
        bottomSheetViewTopConstraint?.constant = safeAreaHeight + bottomPadding
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedView.alpha = 0
            self.view.layoutIfNeeded()
        }) { _ in
            if self.presentingViewController != nil {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
}

extension HomeCalendarDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let challenges = challenges else { return 0 }
        return challenges.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let challenges = self.challenges else { return UITableViewCell() }
        let cell: HomeCalendarDetailTableViewCell = HomeCalendarDetailTableViewCell(
            style: .subtitle,
            reuseIdentifier: HomeCalendarDetailTableViewCell.identifier
        )
        cell.updateCell(challenge: challenges[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}
