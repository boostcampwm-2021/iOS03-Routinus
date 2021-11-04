//
//  ChallengeCollectionViewHeader.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/04.
//

import UIKit

class ChallengeCollectionViewHeader: UICollectionReusableView {
    static let identifier = "ChallengeCollectionViewHeader"

    let label: UILabel = {
        let label = UILabel()
        label.textColor = .black
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

    let seeAllButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("See all", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    
        return button
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()

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

    func addTimeLabel(time: Int) {
        timeLabel.text = "주중 \(time)시 기준"
        stackView.addArrangedSubview(timeLabel)
    }

    func removeStackSubviews() {
        seeAllButton.removeFromSuperview()
        timeLabel.removeFromSuperview()
    }
}
