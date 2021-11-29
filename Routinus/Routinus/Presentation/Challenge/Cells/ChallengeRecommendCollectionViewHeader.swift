//
//  ChallengeRecommendCollectionViewHeader.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/24.
//

import UIKit

final class ChallengeRecommendCollectionViewHeader: UICollectionReusableView {
    static let identifier = "ChallengeRecommendCollectionViewHeader"

    weak var delegate: ChallengeRecommendHeaderDelegate?

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "challenge".localized
        label.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width <= 350 ? 30 : 34,
                                       weight: .bold)
        return label
    }()

    private let stackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }

    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = UIColor(named: "Black")
        button.addTarget(self, action: #selector(didTappedSearchButton), for: .touchUpInside)
        return button
    }()

    @objc func didTappedSearchButton() {
        delegate?.didTappedSearchButton()
    }

    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }

    func configureViews() {
        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
    }

    func addSearchButton() {
        stackView.addArrangedSubview(searchButton)
    }
}
