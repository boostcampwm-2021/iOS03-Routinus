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
    private lazy var profileView = MyPageProfileView()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "UITableViewCell")
        return tableView
    }()
    private lazy var segmentedControl: UISegmentedControl = {
        let items = ["Auto", "Light", "Dark"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self,
                                   action: #selector(didChangeSegmentedControlValue(_:)),
                                   for: .valueChanged)
        return segmentedControl
    }()
    private lazy var versionLabel: UILabel = {
        let label = UILabel()
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        label.font = .systemFont(ofSize: 18)
        label.text = "v\(version ?? "0.0")"
        label.textColor = .systemGray
        return label
    }()

    private var viewModel: MyPageViewModelIO?
    private var cancellables = Set<AnyCancellable>()

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
        configureViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
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
                           height: 190)

        self.view.addSubview(tableView)
        tableView.anchor(leading: view.leadingAnchor,
                         trailing: view.trailingAnchor,
                         top: profileView.bottomAnchor,
                         paddingTop: 20,
                         height: 150)

        self.view.addSubview(versionLabel)
        versionLabel.anchor(centerX: versionLabel.superview?.centerXAnchor,
                            top: tableView.bottomAnchor,
                            paddingTop: 10)
    }

    private func configureDelegates() {
        self.profileView.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    private func configureViewModel() {
        self.viewModel?.user
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] user in
                self?.profileView.setName(user.name)
            })
            .store(in: &cancellables)

        self.viewModel?.themeStyle
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] style in
                self?.segmentedControl.selectedSegmentIndex = style
                self?.setThemeStyle(style)
            })
            .store(in: &cancellables)
    }
}

extension MyPageViewController {
    @objc private func didChangeSegmentedControlValue(_ sender: UISegmentedControl) {
        setThemeStyle(sender.selectedSegmentIndex)
    }

    private func setThemeStyle(_ style: Int) {
        guard let style = UIUserInterfaceStyle(rawValue: style),
              let window = self.view.window else { return }

        UIView.transition(with: window,
                          duration: 0.4,
                          options: .transitionCrossDissolve) {
            window.overrideUserInterfaceStyle = style
        }
        viewModel?.updateThemeStyle(style.rawValue)
    }
}

extension MyPageViewController: MyPageUserNameUpdatableDelegate, UITextFieldDelegate {
    func didTappedNameStackView() {
        let alert = UIAlertController(title: "이름 수정",
                                      message: "최대 8글자로 입력해주세요",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            guard let name = alert.textFields?.first?.text,
                  !name.isEmpty else { return }
            self?.updateUsername(name)
        }
        let cancelAction = UIAlertAction(title: "취소",
                                         style: .cancel)

        alert.addTextField { [weak self] textField in
            textField.delegate = self
            textField.text = self?.profileView.name
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }

    private func updateUsername(_ name: String) {
        self.viewModel?.updateUsername(name)
        self.profileView.setName(name)
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.count > 8 {
            textField.deleteBackward()
        }
    }
}

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    enum MyPageSettings: Int, CaseIterable {
        case theme = 0
        case developer = 1
        case version = 2

        func title() -> String {
            switch self {
            case .theme:
                return "테마 설정"
            case .developer:
                return "개발자 정보"
            case .version:
                return "앱 버전"
            }
        }
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return MyPageSettings.allCases.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.textLabel?.text = MyPageSettings(rawValue: indexPath.row)?.title()
        cell.imageView?.tintColor = UIColor(named: "MainColor")

        switch indexPath.row {
        case 0:
            cell.imageView?.image = UIImage(systemName: "paintbrush.fill")
            cell.accessoryView = self.segmentedControl
        case 1:
            cell.imageView?.image = UIImage(systemName: "person.2.fill")
            cell.accessoryType = .disclosureIndicator
        case 2:
            cell.imageView?.image = UIImage(systemName: "exclamationmark.circle.fill")
            cell.accessoryView = self.versionLabel
        default:
            break
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            self.viewModel?.didTappedDeveloperCell()
        default:
            break
        }
    }
}
