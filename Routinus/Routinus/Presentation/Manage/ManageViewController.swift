//
//  ManageViewController.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/02.
//

import UIKit

import SnapKit

final class ManageViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }

    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.addTarget(self, action: #selector(didTouchAddButton), for: .touchUpInside)
        button.tintColor = UIColor.black
        return button
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ManageView")
        imageView.contentMode = .scaleToFill
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
        return imageView
    }()

    @objc func didTouchAddButton() {
        let vc = CreateViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func configureViews() {
        self.view.backgroundColor = .white
        self.view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide).inset(20)
        }

        self.view.addSubview(plusButton)
        plusButton.snp.makeConstraints { make in
            make.top.equalTo(imageView).offset(30)
            make.trailing.equalTo(imageView).offset(-20)
        }
        
        self.configureNavigationBar()
    }

    private func configureNavigationBar() {
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
}
