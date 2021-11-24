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

    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "Black")
        label.font = UIFont.boldSystemFont(ofSize: 18)

        return label
    }()

    private let stackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureViews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }

    private lazy var seeAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("See all", for: .normal)
        button.setTitleColor(UIColor(named: "Black"), for: .normal)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.addTarget(self, action: #selector(didTappedSeeAllButton), for: .touchUpInside)
        return button
    }()

    @objc func didTappedSeeAllButton() {
        self.delegate?.didTappedSeeAllButton()
    }

    var title: String = "" {
        didSet {
            self.label.text = title
        }
    }

    func configureViews() {
        addSubview(stackView)
        stackView.addArrangedSubview(label)
    }

    func addSeeAllButton() {
        stackView.addArrangedSubview(seeAllButton)
    }

    func removeStackSubviews() {
        seeAllButton.removeFromSuperview()
    }
}
