//
//  ChallengeCollectionViewLayouts.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/04.
//

import UIKit

final class ChallengeCollectionViewLayouts {
    private var recommendLayout: NSCollectionLayoutSection {
        let smallWidth = UIScreen.main.bounds.width <= 350
        let offset = smallWidth ? 15.0 : 25.0

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8),
                                               heightDimension: .estimated(170))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = .init(top: 30, leading: offset, bottom: 20, trailing: offset)
        section.interGroupSpacing = 20
        return section
    }

    private var mainLayout: NSCollectionLayoutSection {
        let smallWidth = UIScreen.main.bounds.width <= 350
        let offset = smallWidth ? 15.0 : 25.0

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .estimated(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [.init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                      heightDimension: .absolute(70)),
                                                    elementKind: UICollectionView.elementKindSectionHeader,
                                                    alignment: .topLeading)]

        section.orthogonalScrollingBehavior = .none
        section.contentInsets = .init(top: 0, leading: offset, bottom: 0, trailing: offset)
        return section
    }

    func section(at sectionNumber: Int) -> NSCollectionLayoutSection {
        if sectionNumber == 0 {
            return self.recommendLayout
        } else {
            return self.mainLayout
        }
    }
}
