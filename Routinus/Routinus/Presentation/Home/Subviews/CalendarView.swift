//
//  CalendarView.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/14.
//

import Combine
import UIKit

final class CalendarView: UIView {
    private lazy var calendarView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        layout.collectionView?.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        layout.collectionView?.layer.cornerCurve = .continuous
        layout.collectionView?.layer.cornerRadius = 15
        return collectionView
    }()

    private lazy var headerView = CalendarHeader(
        didTapLastMonthCompletionHandler: { [weak self] in
            guard let self = self else { return }
            self.viewModel?.changeDate(month: -1)
            self.calendarView.reloadData()
        },
        didTapNextMonthCompletionHandler: { [weak self] in
            guard let self = self else { return }
            self.viewModel?.changeDate(month: 1)
            self.calendarView.reloadData()
        })

    private var viewModel: HomeViewModelIO? = nil
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

    init(viewModel: HomeViewModelIO?) {
        self.viewModel = viewModel
        super.init(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0, height: 0)))
        self.configureView()
        self.configureViewModel()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }

    func configureView() {
        self.addSubview(calendarView)
        self.addSubview(headerView)

        var constraints = [
            headerView.leadingAnchor.constraint(equalTo: self.readableContentGuide.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: self.readableContentGuide.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 85),
            headerView.topAnchor.constraint(equalTo: self.readableContentGuide.topAnchor)
        ]

        constraints.append(contentsOf: [
            calendarView.leadingAnchor.constraint(equalTo: self.headerView.leadingAnchor),
            calendarView.trailingAnchor.constraint(equalTo: self.headerView.trailingAnchor),
            calendarView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor),
            calendarView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8)
        ])

        NSLayoutConstraint.activate(constraints)

        calendarView.register(
            CalendarDateCell.self,
            forCellWithReuseIdentifier: CalendarDateCell.reuseIdentifier
        )

        headerView.baseDate = self.viewModel?.baseDate.value ?? Date()
    }

    func reloadData() {
        self.calendarView.reloadData()
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
}
