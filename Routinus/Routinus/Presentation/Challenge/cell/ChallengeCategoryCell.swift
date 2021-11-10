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
        button.setImage(UIImage(named: Challenge.Category.exercise.categoryImage))
        button.setTitle("운동")

        let gesture = CategoryButtonTapGesture(target: self, action: #selector(didTappedCategoryButton))
        gesture.numberOfTapsRequired = 1
        gesture.configureCategory(category: Challenge.Category.exercise)
        self.isUserInteractionEnabled = true
        button.addGestureRecognizer(gesture)
        return button
    }()

    private lazy var selfDevelopmentButton: CategoryButton = {
        let button = CategoryButton()
        button.setImage(UIImage(systemName: Challenge.Category.selfDevelopment.categoryImage))
        button.setTitle("자기 계발")

        let gesture = CategoryButtonTapGesture(target: self, action: #selector(didTappedCategoryButton))
        gesture.numberOfTapsRequired = 1
        gesture.configureCategory(category: Challenge.Category.selfDevelopment)
        self.isUserInteractionEnabled = true
        button.addGestureRecognizer(gesture)
        return button
    }()

    private lazy var lifeStyleButton: CategoryButton = {
        let button = CategoryButton()
        button.setImage(UIImage(named: Challenge.Category.lifeStyle.categoryImage))
        button.setTitle("생활 습관")

        let gesture = CategoryButtonTapGesture(target: self, action: #selector(didTappedCategoryButton))
        gesture.numberOfTapsRequired = 1
        gesture.configureCategory(category: Challenge.Category.lifeStyle)
        self.isUserInteractionEnabled = true
        button.addGestureRecognizer(gesture)
        return button
    }()

    private lazy var financeButton: CategoryButton = {
        let button = CategoryButton()
        button.setImage(UIImage(systemName: Challenge.Category.finance.categoryImage))
        button.setTitle("돈관리")

        let gesture = CategoryButtonTapGesture(target: self, action: #selector(didTappedCategoryButton))
        gesture.numberOfTapsRequired = 1
        gesture.configureCategory(category: Challenge.Category.finance)
        self.isUserInteractionEnabled = true
        button.addGestureRecognizer(gesture)
        return button
    }()

    private lazy var hobbyButton: CategoryButton = {
        let button = CategoryButton()
        button.setImage(UIImage(systemName: Challenge.Category.hobby.categoryImage))
        button.setTitle("취미")

        let gesture = CategoryButtonTapGesture(target: self, action: #selector(didTappedCategoryButton))
        gesture.numberOfTapsRequired = 1
        gesture.configureCategory(category: Challenge.Category.hobby)
        self.isUserInteractionEnabled = true
        button.addGestureRecognizer(gesture)
        return button
    }()

    private lazy var etcButton: CategoryButton = {
        let button = CategoryButton()
        button.setImage(UIImage(systemName: Challenge.Category.etc.categoryImage))
        button.setTitle("기타")

        let gesture = CategoryButtonTapGesture(target: self, action: #selector(didTappedCategoryButton))
        gesture.numberOfTapsRequired = 1
        gesture.configureCategory(category: Challenge.Category.etc)
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
        xStackView1.addArrangedSubview(selfDevelopmentButton)
        xStackView1.addArrangedSubview(lifeStyleButton)

        self.yStackView.addArrangedSubview(xStackView2)
        xStackView2.addArrangedSubview(financeButton)
        xStackView2.addArrangedSubview(hobbyButton)
        xStackView2.addArrangedSubview(etcButton)
    }
}

protocol ChallengeCategoryCellDelegate: AnyObject {
    func didTappedCategoryButton(category: Challenge.Category)
}
