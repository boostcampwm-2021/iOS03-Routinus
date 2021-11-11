//
//  AuthViewController.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/02.
//

import UIKit

class AuthViewController: UIViewController {

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "AuthView")
        imageView.contentMode = .scaleToFill
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.configureViews()
    }

    func configureViews() {
        self.view.backgroundColor = .white
        self.view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide).inset(20)
        }
    }
}
