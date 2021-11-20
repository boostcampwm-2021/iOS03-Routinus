//
 //  ManageCollectionViewHeader.swift
 //  Routinus
 //
 //  Created by 김민서 on 2021/11/20.
 //

 import UIKit

final class ManageCollectionViewHeader: UICollectionReusableView {
    enum Section {
        case participated, created

        var title: String {
            switch self {
            case .participated:
                return "내가 참여한 챌린지"
            case .created:
                return "내가 생성한 챌린지"
            }
        }
    }

    static let identifier = "ManageCollectionViewHeader"

    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "Black")
        label.font = UIFont.boldSystemFont(ofSize: 18)

        return label
    }()

    private lazy var toggleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.down"),
                         for: .normal)
        button.tintColor = UIColor(named: "Black")
        return button
    }()

    private lazy var stackView = UIStackView()
    private(set) var section: Section?
    private var isExpanded: Bool = true {
        didSet {
            if isExpanded == true {
                toggleButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            } else {
                toggleButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
            }
        }
    }

    func configureViews(section: Section) {
        self.section = section
        label.text = section.title

        addSubview(stackView)
        stackView.anchor(horizontal: self,
                         centerY: centerYAnchor)
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(toggleButton)
    }

    func didTouchedHeader() {
        isExpanded.toggle()
    }
}
