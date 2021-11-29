//
//  ManageCollectionViewHeader.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/20.
//

import UIKit

final class ManageCollectionViewHeader: UICollectionReusableView {
    enum Section: Int {
        case participating = 1, created, ended

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

    private lazy var toggleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.tintColor = UIColor(named: "Black")
        return imageView
    }()

    private(set) var section: Section?
    public var isExpanded: Bool = true {
        didSet {
            let angle = isExpanded ? 0 : -Double.pi / 2
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3) {
                    self.toggleImageView.transform = CGAffineTransform(rotationAngle: angle)
                }
            }
        }
    }

    func configureViews(section: Section) {
        self.section = section
        label.text = section.title

        addSubview(label)
        label.anchor(leading: leadingAnchor, centerY: centerYAnchor)

        addSubview(toggleImageView)
        toggleImageView.anchor(trailing: trailingAnchor, centerY: centerYAnchor)
    }

    func didTouchedHeader() {
        isExpanded.toggle()
    }
}
