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

    private let stackView = UIStackView()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "challenges".localized
        label.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width <= 350 ? 30 : 34,
                                       weight: .bold)
        return label
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = UIColor(named: "Black")
        button.addTarget(self, action: #selector(didTappedSearchButton), for: .touchUpInside)
        return button
    }()

    var title: String = "" {
        didSet {
            titleLabel.text = title
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

    func addSearchButton() {
        stackView.addArrangedSubview(searchButton)
    }
}

extension ChallengeRecommendCollectionViewHeader {
    private func configure() {
        configureView()
    }

    private func configureView() {
        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
    }

    @objc private func didTappedSearchButton() {
        delegate?.didTappedSearchButton()
    }
}
