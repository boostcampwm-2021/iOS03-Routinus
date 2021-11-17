//
//  DetailViewController.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/02.
//

import UIKit

final class DetailViewController: UIViewController {

    private lazy var scrollView: UIScrollView = UIScrollView()
    private lazy var stackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 3
        stackView.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
        return stackView
    }()

    private lazy var mainImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "walk")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var participantView: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        return view
    }()

    private lazy var informationView = InformationView()
    private lazy var authMethodView = AuthMethodView()
    private lazy var participantButton = ParticipantButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViews()
    }

    func configureViews() {
        self.view.backgroundColor = .white
        self.configureNavigationBar()

        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true

        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true

        stackView.addArrangedSubview(mainImageView)
        mainImageView.heightAnchor.constraint(equalToConstant: 300).isActive = true

        stackView.addArrangedSubview(informationView)
        informationView.heightAnchor.constraint(equalToConstant: 250).isActive = true

        stackView.addArrangedSubview(authMethodView)
        authMethodView.heightAnchor.constraint(equalToConstant: 300).isActive = true

        stackView.addArrangedSubview(participantView)
        participantView.heightAnchor.constraint(equalToConstant: 100).isActive = true

        participantView.addSubview(participantButton)
        participantButton.translatesAutoresizingMaskIntoConstraints = false
        participantButton.topAnchor.constraint(equalTo: participantView.topAnchor, constant: 20).isActive = true
        participantButton.bottomAnchor.constraint(equalTo: participantView.bottomAnchor, constant: -20).isActive = true
        participantButton.leadingAnchor.constraint(equalTo: participantView.leadingAnchor, constant: 20).isActive = true
        participantButton.trailingAnchor.constraint(equalTo: participantView.trailingAnchor, constant: -20).isActive = true
    }

    private func configureNavigationBar() {
        self.navigationItem.largeTitleDisplayMode = .never
        // TODO: 챌린지 연동
        // TODO: 작성자인 경우에만 rightBarButtonItem 보이기
        self.navigationItem.title = "1만보 걷기"
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: nil)
        rightBarButtonItem.tintColor = .black
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
}
