//
//  ChallengeCollectionViewHeader.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/04.
//

import UIKit

final class ChallengeCategoryCollectionViewHeader: UICollectionReusableView {
    static let identifier = "ChallengeCategoryCollectionViewHeader"

    weak var delegate: ChallengeCategoryHeaderDelegate?

    private let stackView = UIStackView()

    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "SystemForeground")
        label.font = UIFont.boldSystemFont(ofSize: 18)

        return label
    }()

    private lazy var seeAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("See all", for: .normal)
        button.setTitleColor(UIColor(named: "SystemForeground"), for: .normal)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.addTarget(self, action: #selector(didTappedSeeAllButton), for: .touchUpInside)
        return button
    }()

    var title: String = "" {
        didSet {
            label.text = title
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }

    func addSeeAllButton() {
        stackView.addArrangedSubview(seeAllButton)
    }
}

extension ChallengeCategoryCollectionViewHeader {
    private func configure() {
        configureView()
    }

    private func configureView() {
        addSubview(stackView)
        stackView.addArrangedSubview(label)
    }

    @objc private func didTappedSeeAllButton() {
        delegate?.didTappedSeeAllButton()
    }
}
