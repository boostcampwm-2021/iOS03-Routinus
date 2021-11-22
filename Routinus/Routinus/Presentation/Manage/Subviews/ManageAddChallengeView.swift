//
//  AddChallengeView.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/20.
//

import UIKit

protocol AddChallengeDelegate: AnyObject {
    func didTappedAddButton()
}

final class ManageAddChallengeView: UIView {
    weak var delegate: AddChallengeDelegate?

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "원하는 챌린지를\n직접 만들어보세요!"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()

    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle("챌린지 개설하기", for: .normal)
        button.setTitleColor(.systemBackground, for: .normal)
        button.backgroundColor = UIColor(named: "MainColor")
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(didTappedAddButton), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }

    convenience init() {
        self.init(frame: CGRect.zero)
    }
}

extension ManageAddChallengeView {
    private func configureView() {
        backgroundColor = UIColor(named: "MainColor")?.withAlphaComponent(0.5)
        layer.cornerRadius = 10
        anchor(height: 160)

        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(addButton)
        stackView.anchor(centerX: centerXAnchor,
                         centerY: centerYAnchor)
    }

    @objc func didTappedAddButton() {
        delegate?.didTappedAddButton()
    }
}