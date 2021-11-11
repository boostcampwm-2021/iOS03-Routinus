//
//  CollectionViewLayouts.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/04.
//

import UIKit

class CollectionViewLayouts {
    private var recommendLayout: NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .estimated(170))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = .init(top: 30, leading: 25, bottom: 20, trailing: 25)
        section.interGroupSpacing = 20
        return section
    }

    private var mainLayout: NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [.init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                      heightDimension: .absolute(70)),
                                                    elementKind: UICollectionView.elementKindSectionHeader,
                                                    alignment: .topLeading)]

        section.orthogonalScrollingBehavior = .none
        section.contentInsets = .init(top: 0, leading: 25, bottom: 0, trailing: 25)
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
