//
//  MyPageViewController.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/02.
//

import Combine
import UIKit

final class MyPageViewController: UIViewController {
    private lazy var scrollView: UIScrollView = UIScrollView()
    private lazy var contentView: UIView = UIView()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width <= 350 ? 30 : 34,
                                       weight: .bold)
        label.text = "마이페이지"
        return label
    }()
    private lazy var profileView = ProfileView()
    
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

        self.view.addSubview(scrollView)
        scrollView.anchor(edges: view.safeAreaLayoutGuide)

        self.scrollView.addSubview(contentView)
        contentView.anchor(centerX: contentView.superview?.centerXAnchor,
                           vertical: contentView.superview,
                           width: UIScreen.main.bounds.width)

        self.contentView.addSubview(titleLabel)
        titleLabel.anchor(horizontal: titleLabel.superview,
                          paddingHorizontal: offset,
                          top: titleLabel.superview?.topAnchor,
                          paddingTop: smallWidth ? 28 : 32,
                          height: 80)

        self.contentView.addSubview(profileView)
        profileView.anchor(horizontal: profileView.superview,
                           paddingHorizontal: offset,
                           top: titleLabel.bottomAnchor,
                           paddingTop: 10,
                           height: 150)
    }
}
