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
        stack.spacing = 30
        return stack
    }()

    private lazy var xStackView2: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 30
        return stack
    }()

    private lazy var exerciseButton: CategoryButton = {
        let button = CategoryButton()
        let category = Challenge.Category.exercise
        button.setImage(UIImage(named: category.symbol))
        button.setTitle(category.title)
        button.setTintColor(UIColor(named: category.color))

        let gesture = CategoryButtonTapGesture(target: self, action: #selector(didTappedCategoryButton))
        gesture.numberOfTapsRequired = 1
        gesture.configureCategory(category: category)
        self.isUserInteractionEnabled = true
        button.addGestureRecognizer(gesture)
        return button
    }()

    private lazy var studyButton: CategoryButton = {
        let button = CategoryButton()
        let category = Challenge.Category.study
        button.setImage(UIImage(systemName: category.symbol))
        button.setTitle(category.title)
        button.setTintColor(UIColor(named: category.color))

        let gesture = CategoryButtonTapGesture(target: self, action: #selector(didTappedCategoryButton))
        gesture.numberOfTapsRequired = 1
        gesture.configureCategory(category: category)
        self.isUserInteractionEnabled = true
        button.addGestureRecognizer(gesture)
        return button
    }()

    private lazy var readButton: CategoryButton = {
        let button = CategoryButton()
        let category = Challenge.Category.read
        button.setImage(UIImage(systemName: category.symbol))
        button.setTitle(category.title)
        button.setTintColor(UIColor(named: category.color))

        let gesture = CategoryButtonTapGesture(target: self, action: #selector(didTappedCategoryButton))
        gesture.numberOfTapsRequired = 1
        gesture.configureCategory(category: category)
        self.isUserInteractionEnabled = true
        button.addGestureRecognizer(gesture)
        return button
    }()

    private lazy var lifeStyleButton: CategoryButton = {
        let button = CategoryButton()
        let category = Challenge.Category.lifeStyle
        button.setImage(UIImage(named: category.symbol))
        button.setTitle(category.title)
        button.setTintColor(UIColor(named: category.color))

        let gesture = CategoryButtonTapGesture(target: self, action: #selector(didTappedCategoryButton))
        gesture.numberOfTapsRequired = 1
        gesture.configureCategory(category: category)
        self.isUserInteractionEnabled = true
        button.addGestureRecognizer(gesture)
        return button
    }()

    private lazy var financeButton: CategoryButton = {
        let button = CategoryButton()
        let category = Challenge.Category.finance
        button.setImage(UIImage(systemName: category.symbol))
        button.setTitle(category.title)
        button.setTintColor(UIColor(named: category.color))

        let gesture = CategoryButtonTapGesture(target: self, action: #selector(didTappedCategoryButton))
        gesture.numberOfTapsRequired = 1
        gesture.configureCategory(category: category)
        self.isUserInteractionEnabled = true
        button.addGestureRecognizer(gesture)
        return button
    }()

    private lazy var hobbyButton: CategoryButton = {
        let button = CategoryButton()
        let category = Challenge.Category.hobby
        button.setImage(UIImage(systemName: category.symbol))
        button.setTitle(category.title)
        button.setTintColor(UIColor(named: category.color))

        let gesture = CategoryButtonTapGesture(target: self, action: #selector(didTappedCategoryButton))
        gesture.numberOfTapsRequired = 1
        gesture.configureCategory(category: category)
        self.isUserInteractionEnabled = true
        button.addGestureRecognizer(gesture)
        return button
    }()

    private lazy var emotionManageButton: CategoryButton = {
        let button = CategoryButton()
        let category = Challenge.Category.emotionManage
        button.setImage(UIImage(systemName: category.symbol))
        button.setTitle(category.title)
        button.setTintColor(UIColor(named: category.color))

        let gesture = CategoryButtonTapGesture(target: self, action: #selector(didTappedCategoryButton))
        gesture.numberOfTapsRequired = 1
        gesture.configureCategory(category: category)
        self.isUserInteractionEnabled = true
        button.addGestureRecognizer(gesture)
        return button
    }()

    private lazy var etcButton: CategoryButton = {
        let button = CategoryButton()
        let category = Challenge.Category.etc
        button.setImage(UIImage(systemName: category.symbol))
        button.setTitle(category.title)
        button.setTintColor(UIColor(named: category.color))

        let gesture = CategoryButtonTapGesture(target: self, action: #selector(didTappedCategoryButton))
        gesture.numberOfTapsRequired = 1
        gesture.configureCategory(category: category)
        self.isUserInteractionEnabled = true
        button.addGestureRecognizer(gesture)
        return button
    }()

    @objc func didTappedCategoryButton(_ gesture: CategoryButtonTapGesture) {
        guard let category = gesture.category else { return }
        delegate?.didTappedCategoryButton(category: category)
    }

    func configureViews() {
        self.addSubview(yStackView)
        yStackView.snp.makeConstraints { make in
            make.centerX.top.equalToSuperview()
        }

        self.yStackView.addArrangedSubview(xStackView1)
        xStackView1.addArrangedSubview(exerciseButton)
        xStackView1.addArrangedSubview(studyButton)
        xStackView1.addArrangedSubview(readButton)
        xStackView1.addArrangedSubview(lifeStyleButton)

        self.yStackView.addArrangedSubview(xStackView2)
        xStackView2.addArrangedSubview(financeButton)
        xStackView2.addArrangedSubview(hobbyButton)
        xStackView2.addArrangedSubview(emotionManageButton)
        xStackView2.addArrangedSubview(etcButton)
    }
}

protocol ChallengeCategoryCellDelegate: AnyObject {
    func didTappedCategoryButton(category: Challenge.Category)
}
