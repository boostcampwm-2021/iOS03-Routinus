//
//  ChallengeCategoryCell.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/04.
//

import UIKit

final class ChallengeCategoryCell: UICollectionViewCell {
    static let identifier = "categoryCell"
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

    @objc func didTappedCategoryButton(_ gesture: CategoryButtonTapGesture) {
        guard let category = gesture.category else { return }
        delegate?.didTappedCategoryButton(category: category)
    }

    func configureViews() {
        self.addSubview(yStackView)
        yStackView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.trailing.equalToSuperview()
        }

        self.yStackView.addArrangedSubview(xStackView1)
        self.yStackView.addArrangedSubview(xStackView2)

        for (index, category) in Challenge.Category.allCases.enumerated() {
            let button = CategoryButton()
            button.setImage(UIImage(named: category.symbol) != nil
                            ? UIImage(named: category.symbol)
                            : UIImage(systemName: category.symbol))
            button.setTitle(category.title)
            button.setTintColor(UIColor(named: category.color))

            let gesture = CategoryButtonTapGesture(target: self, action: #selector(didTappedCategoryButton))
            gesture.numberOfTapsRequired = 1
            gesture.configureCategory(category: category)
            self.isUserInteractionEnabled = true
            button.addGestureRecognizer(gesture)

            if index < 4 {
                self.xStackView1.addArrangedSubview(button)
            } else {
                self.xStackView2.addArrangedSubview(button)
            }
        }
    }
}

protocol ChallengeCategoryCellDelegate: AnyObject {
    func didTappedCategoryButton(category: Challenge.Category)
}
