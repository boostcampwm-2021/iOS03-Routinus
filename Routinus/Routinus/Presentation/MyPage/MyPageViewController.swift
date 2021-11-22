//
//  MyPageViewController.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/02.
//

import Combine
import UIKit

final class MyPageViewController: UIViewController {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width <= 350 ? 30 : 34,
                                       weight: .bold)
        label.text = "마이페이지"
        return label
    }()
    private lazy var profileView = ProfileView()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "UITableViewCell")
        return tableView
    }()
    private lazy var segmentedControl: UISegmentedControl = {
        let items = ["Light", "Dark", "Auto"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 2
        segmentedControl.layer.shadowPath = UIBezierPath(rect: segmentedControl.bounds).cgPath
        segmentedControl.addTarget(self,
                                   action: #selector(didChangeSegmentedControlValue(_:)),
                                   for: .valueChanged)
        return segmentedControl
    }()

    private var viewModel: MyPageViewModelIO?

    init(with viewModel: MyPageViewModelIO) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        configureDelegates()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @objc private func didChangeSegmentedControlValue(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex) // TODO: 구현
    }
}

extension MyPageViewController {
    private func configureViews() {
        let smallWidth = UIScreen.main.bounds.width <= 350
        let offset = smallWidth ? 15.0 : 20.0

        self.view.backgroundColor = .systemBackground

        self.view.addSubview(titleLabel)
        titleLabel.anchor(horizontal: titleLabel.superview,
                          paddingHorizontal: offset,
                          top: view.safeAreaLayoutGuide.topAnchor,
                          paddingTop: smallWidth ? 28 : 32,
                          height: 80)

        self.view.addSubview(profileView)
        profileView.anchor(horizontal: profileView.superview,
                           paddingHorizontal: offset,
                           top: titleLabel.bottomAnchor,
                           paddingTop: 10,
                           height: 180)

        self.view.addSubview(tableView)
        tableView.anchor(leading: view.leadingAnchor,
                         trailing: view.trailingAnchor,
                         top: profileView.bottomAnchor,
                         paddingTop: 30,
                         height: 200)
    }

    private func configureDelegates() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
}

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    enum MyPageSettings: Int, CaseIterable {
        case theme = 0
        case developer = 1
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return MyPageSettings.allCases.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.imageView?.tintColor = UIColor(named: "MainColor")

        switch indexPath.row {
        case 0:
            cell.imageView?.image = UIImage(systemName: "paintbrush.fill")
            cell.textLabel?.text = "테마 설정"
            cell.accessoryView = self.segmentedControl
        case 1:
            cell.imageView?.image = UIImage(systemName: "person.2.fill")
            cell.textLabel?.text = "개발자 정보"
            cell.accessoryType = .disclosureIndicator
        default:
            break
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            print("개발자 정보 클릭됨!") // TODO: 구현
        default:
            break
        }
    }
}
