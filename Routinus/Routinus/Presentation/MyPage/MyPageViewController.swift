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
        label.text = "mypage".localized
        return label
    }()
    private lazy var profileView = MyPageProfileView()
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
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
        label.textColor = UIColor(named: "DayColor")
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
        configure()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

extension MyPageViewController {
    private func configure() {
        configureViews()
        configureViewModel()
        configureDelegates()
    }

    private func configureViews() {
        let smallWidth = UIScreen.main.bounds.width <= 350
        let offset = smallWidth ? 15.0 : 20.0

        view.backgroundColor = UIColor(named: "SystemBackground")

        view.addSubview(titleLabel)
        titleLabel.anchor(horizontal: titleLabel.superview,
                          paddingHorizontal: offset,
                          top: view.safeAreaLayoutGuide.topAnchor,
                          paddingTop: smallWidth ? 28 : 32,
                          height: 80)

        view.addSubview(profileView)
        profileView.anchor(horizontal: profileView.superview,
                           paddingHorizontal: offset,
                           top: titleLabel.bottomAnchor,
                           paddingTop: 10,
                           height: 190)

        view.addSubview(tableView)
        tableView.anchor(leading: view.leadingAnchor,
                         trailing: view.trailingAnchor,
                         top: profileView.bottomAnchor,
                         paddingTop: 20,
                         height: 150)

        view.addSubview(versionLabel)
        versionLabel.anchor(centerX: versionLabel.superview?.centerXAnchor,
                            top: tableView.bottomAnchor,
                            paddingTop: 10)
    }

    private func configureViewModel() {
        viewModel?.user
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] user in
                guard let self = self else { return }
                self.profileView.updateName(user.name)
                self.profileView.updateImage(with: user)
            })
            .store(in: &cancellables)

        viewModel?.themeStyle
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] style in
                guard let self = self else { return }
                self.segmentedControl.selectedSegmentIndex = style
                self.updateThemeStyle(style)
            })
            .store(in: &cancellables)
    }

    private func configureDelegates() {
        profileView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func updateUsername(_ name: String) {
        viewModel?.updateUsername(name)
        profileView.updateName(name)
    }

    private func updateThemeStyle(_ style: Int) {
        guard let style = UIUserInterfaceStyle(rawValue: style) else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            UIView.animate(withDuration: 0.4) {
                self.view.window?.overrideUserInterfaceStyle = style
            }
        }
        viewModel?.updateThemeStyle(style.rawValue)
    }

    private func impactLight() {
        let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        impactFeedbackGenerator.impactOccurred()
    }

    @objc private func didChangeSegmentedControlValue(_ sender: UISegmentedControl) {
        updateThemeStyle(sender.selectedSegmentIndex)
    }
}

extension MyPageViewController: UITextFieldDelegate, MyPageUserNameUpdatableDelegate {
    func didTappedNameStackView() {
        let alert = UIAlertController(title: "edit name".localized,
                                      message: "name max 8".localized,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok".localized, style: .default) { [weak self] _ in
            guard let self = self,
                  let name = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !name.isEmpty else { return }
            self.updateUsername(name)
        }
        let cancelAction = UIAlertAction(title: "cancel".localized, style: .cancel)

        alert.addTextField { [weak self] textField in
            guard let self = self else { return }
            textField.delegate = self
            textField.text = self.profileView.name
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.count > 8 {
            impactLight()
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
                return "theme setting"
            case .developer:
                return "developer info"
            case .version:
                return "app version"
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyPageSettings.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.selectionStyle = .none
        cell.textLabel?.text = MyPageSettings(rawValue: indexPath.row)?.title().localized
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
            guard let url = URL(string: "https://github.com/boostcampwm-2021/iOS03-Routinus"),
                  UIApplication.shared.canOpenURL(url) else { return }
            UIApplication.shared.open(url)
        default:
            break
        }
    }
}
