//
//  ManageCollectionViewHeader.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/20.
//

import UIKit

final class ManageCollectionViewHeader: UICollectionReusableView {
    enum Section {
        case participating, created, ended

        var title: String {
            switch self {
            case .participating:
                return "participatingChallenges".localized
            case .created:
                return "createdChallenges".localized
            case .ended:
                return "endedChallenges".localized
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

    private lazy var toggleImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.tintColor = UIColor(named: "Black")
        return imageView
    }()

    private(set) var section: Section?
    private(set) var isExpanded: Bool = true {
        didSet {
            if isExpanded == true {
                toggleImage.image  = UIImage(systemName: "chevron.down")
            } else {
                toggleImage.image = UIImage(systemName: "chevron.right")
            }
        }
    }

    func configureViews(section: Section) {
        self.section = section
        label.text = section.title

        addSubview(label)
        label.anchor(left: self.leftAnchor,
                         centerY: centerYAnchor)

        addSubview(toggleImage)
        toggleImage.anchor(right: self.rightAnchor,
                         centerY: centerYAnchor)
    }

    func didTouchedHeader() {
        isExpanded.toggle()
    }
}
