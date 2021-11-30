//
//  ChallengeCategoryCollectionViewCell.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/04.
//

import UIKit

final class ChallengeCategoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "ChallengeCategoryCollectionViewCell"

    weak var delegate: ChallengeCategoryCellDelegate?

    private lazy var yStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 25
        return stack
    }()

    private lazy var xStackView1: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        return stack
    }()

    private lazy var xStackView2: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        return stack
    }()

    @objc func didTappedCategoryButton(_ gesture: ChallengeCategoryIconViewTapGesture) {
        guard let category = gesture.category else { return }
        delegate?.didTappedCategoryButton(category: category)
    }

    func configureViews() {
        addSubview(yStackView)
        yStackView.anchor(horizontal: yStackView.superview, top: yStackView.superview?.topAnchor)

        yStackView.addArrangedSubview(xStackView1)
        yStackView.addArrangedSubview(xStackView2)

        for (index, category) in Challenge.Category.allCases.enumerated() {
            let button = ChallengeCategoryIconView()
            button.updateImage(UIImage(named: category.symbol) != nil ? UIImage(named: category.symbol) : UIImage(systemName: category.symbol))
            button.updateTitle(category.title)
            button.updateTintColor(UIColor(named: category.color))

            let gesture = ChallengeCategoryIconViewTapGesture(
                target: self,
                action: #selector(didTappedCategoryButton)
            )
            gesture.numberOfTapsRequired = 1
            gesture.configureCategory(category: category)
            isUserInteractionEnabled = true
            button.addGestureRecognizer(gesture)

            if index < 4 {
                xStackView1.addArrangedSubview(button)
            } else {
                xStackView2.addArrangedSubview(button)
            }
        }
    }
}

protocol ChallengeCategoryCellDelegate: AnyObject {
    func didTappedCategoryButton(category: Challenge.Category)
}
