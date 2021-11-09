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
        stack.spacing = 10
        return stack
    }()

    private lazy var xStackView1: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        return stack
    }()

    private lazy var xStackView2: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        return stack
    }()

    private lazy var exerciseButton: CategoryButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.imagePlacement = .top
        let button = CategoryButton(configuration: configuration, primaryAction: nil)
        button.setImage(UIImage(named: Category.exercise.categoryImage), for: .normal)
        button.setTitle("운동", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.tintColor = .black
        button.categoty = .exercise
        button.addTarget(self, action: #selector(didTappedCategoryButton(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var selfDevelopmentButton: CategoryButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.imagePlacement = .top
        let button =  CategoryButton(configuration: configuration, primaryAction: nil)
        button.setImage(UIImage(systemName: Category.selfDevelopment.categoryImage), for: .normal)
        button.tintColor = .black
        button.setTitle("자기 계발", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.categoty = .selfDevelopment
        button.addTarget(self, action: #selector(didTappedCategoryButton(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var lifeStyleButton: CategoryButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.imagePlacement = .top
        let button =  CategoryButton(configuration: configuration, primaryAction: nil)
        button.setImage(UIImage(named: Category.lifeStyle.categoryImage), for: .normal)
        button.tintColor = .black
        button.setTitle("생활 습관", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.categoty = .lifeStyle
        button.addTarget(self, action: #selector(didTappedCategoryButton(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var financeButton: CategoryButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.imagePlacement = .top
        let button =  CategoryButton(configuration: configuration, primaryAction: nil)
        button.setImage(UIImage(systemName: Category.finance.categoryImage), for: .normal)
        button.tintColor = .black
        button.setTitle("돈관리", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.categoty = .finance
        button.addTarget(self, action: #selector(didTappedCategoryButton(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var hobbyButton: CategoryButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.imagePlacement = .top
        let button =  CategoryButton(configuration: configuration, primaryAction: nil)
        button.setImage(UIImage(systemName: Category.hobby.categoryImage), for: .normal)
        button.setTitle("취미", for: .normal)
        button.tintColor = .black
        button.setTitleColor(.black, for: .normal)
        button.categoty = .hobby
        button.addTarget(self, action: #selector(didTappedCategoryButton(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var etcButton: CategoryButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.imagePlacement = .top
        let button =  CategoryButton(configuration: configuration, primaryAction: nil)
        button.setImage(UIImage(systemName: Category.etc.categoryImage), for: .normal)
        button.setTitle("기타", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.tintColor = .black
        button.categoty = .etc
        button.addTarget(self, action: #selector(didTappedCategoryButton(_:)), for: .touchUpInside)
        return button
    }()

    @objc func didTappedCategoryButton(_ sender: CategoryButton) {
        guard let category = sender.categoty else { return }
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
    func didTappedCategoryButton(category: Category)
}
