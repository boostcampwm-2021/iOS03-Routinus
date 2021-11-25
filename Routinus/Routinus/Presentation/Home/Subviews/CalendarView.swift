//
//  CalendarView.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/14.
//

import Combine
import UIKit

final class CalendarView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.text = "summary".localized
        return label
    }()

    private lazy var questionButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "questionmark.circle"), for: .normal)
        button.tintColor = UIColor(named: "Black")
        button.anchor(width: 24, height: 24)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: #selector(didTappedQuestionButton), for: .touchUpInside)
        return button
    }()

    private lazy var calendarView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 0.5

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false

        layout.collectionView?.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        layout.collectionView?.layer.cornerCurve = .continuous
        layout.collectionView?.layer.cornerRadius = 15
        collectionView.backgroundColor = UIColor(named: "LightGray")
        collectionView.layer.borderWidth = 1
        collectionView.layer.borderColor = UIColor(named: "LightGray")?.cgColor
        return collectionView
    }()

    private lazy var headerView = CalendarHeader(
        didTappedPreviousMonthCompletionHandler: { [weak self] in
            guard let self = self else { return }
            self.viewModel?.changeDate(month: -1)
            self.calendarView.reloadData()
        },
        didTappedNextMonthCompletionHandler: { [weak self] in
            guard let self = self else { return }
            self.viewModel?.changeDate(month: 1)
            self.calendarView.reloadData()
        },
        didTappedTodayCompletionHandler: { [weak self] in
            guard let self = self else { return }
            self.viewModel?.changeDate(month: 0)
            self.calendarView.reloadData()
        })

    private var viewModel: HomeViewModelIO?
    private var cancellables = Set<AnyCancellable>()

    weak var delegate: UICollectionViewDelegateFlowLayout? {
        didSet {
            calendarView.delegate = delegate
        }
    }

    weak var dataSource: UICollectionViewDataSource? {
        didSet {
            calendarView.dataSource = dataSource
        }
    }

    weak var questionDeleatge: QuestionButtonDelegate?

    init(viewModel: HomeViewModelIO?) {
        self.viewModel = viewModel
        super.init(frame: CGRect(origin: .zero, size: .zero))
        self.configureView()
        self.configureViewModel()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
        self.configureViewModel()
    }

    func configureView() {
        self.addSubview(titleLabel)
        self.addSubview(questionButton)
        self.addSubview(calendarView)
        self.addSubview(headerView)

        calendarView.register(
            DateCollectionViewCell.self,
            forCellWithReuseIdentifier: DateCollectionViewCell.reuseIdentifier
        )
        headerView.baseDate = self.viewModel?.baseDate.value ?? Date()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        titleLabel.anchor(horizontal: self,
                          paddingHorizontal: 10,
                          top: readableContentGuide.topAnchor,
                          paddingTop: 10)

        questionButton.anchor(trailing: self.trailingAnchor,
                              paddingTrailing: 10,
                              top: readableContentGuide.topAnchor,
                              paddingTop: 10)

        headerView.anchor(horizontal: headerView.superview,
                          top: titleLabel.bottomAnchor, paddingTop: 20,
                          height: 85)

        calendarView.anchor(horizontal: headerView,
                            top: headerView.bottomAnchor,
                            height: 56 * 6)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            calendarView.layer.borderColor = UIColor(named: "LightGray")?.cgColor
        }
    }

    private func configureViewModel() {
        self.viewModel?.baseDate
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] baseDate in
                guard let self = self else { return }
                self.headerView.baseDate = self.viewModel?.baseDate.value ?? Date()
                self.calendarView.reloadInputViews()
            })
            .store(in: &cancellables)
    }

    func reloadData() {
        self.calendarView.reloadData()
    }
    
    @objc private func didTappedQuestionButton() {
        questionDeleatge?.didTappedQuestionButton()
    }
}

protocol QuestionButtonDelegate: AnyObject {
    func didTappedQuestionButton()
}
