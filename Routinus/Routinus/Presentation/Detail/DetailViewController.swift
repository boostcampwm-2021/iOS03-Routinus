//
//  DetailViewController.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/02.
//

import UIKit

class DetailViewController: UIViewController {

    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        button.addTarget(self, action: #selector(didTouchbackButton), for: .touchUpInside)
        button.tintColor = UIColor.black
        return button
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ChallengeDetailView")
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

        self.view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(70)
            make.leading.equalToSuperview().offset(30)
        }
    }

    @objc func didTouchbackButton() {
        let transition = CATransition()
        transition.duration = 0.35
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false)
    }

}
