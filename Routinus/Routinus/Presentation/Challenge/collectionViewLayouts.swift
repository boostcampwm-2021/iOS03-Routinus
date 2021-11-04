//
//  collectionViewLayouts.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/04.
//

import UIKit

class collectionViewLayouts {
    private var eventsLayout: NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.6), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [.init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                      heightDimension: .absolute(70)),
                                                    elementKind: UICollectionView.elementKindSectionHeader,
                                                    alignment: .topLeading)]
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = .init(top: 0, leading: 16, bottom: 20, trailing: 16)
        section.interGroupSpacing = 16
        return section
    }

    private var mainEventLayout: NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(250))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(250))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.contentInsets = .init(top: 50, leading: 16, bottom: 0, trailing: 16)
        
        return section
    }

    func section(at sectionNumber: Int) -> NSCollectionLayoutSection {
        if sectionNumber == 0 {
            return self.mainEventLayout
        } else {
            return self.eventsLayout
        }
    }
}
