//
//  SearchCollectionViewLayouts.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/09.
//

import UIKit

class SearchCollectionViewLayouts {
    private var pupularSearchTermLayout: NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.2), heightDimension: .estimated(30))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [.init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                      heightDimension: .absolute(70)),
                                                    elementKind: UICollectionView.elementKindSectionHeader,
                                                    alignment: .topLeading)]
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = .init(top: 10, leading: 25, bottom: 20, trailing: 10)
        section.interGroupSpacing = 20
        return section
    }

    private var challengeLayout: NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(140))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(140))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [.init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                      heightDimension: .absolute(70)),
                                                    elementKind: UICollectionView.elementKindSectionHeader,
                                                    alignment: .topLeading)]

        section.orthogonalScrollingBehavior = .none
        section.contentInsets = .init(top: 10, leading: 25, bottom: 10, trailing: 25)
        section.interGroupSpacing = 10
        return section
    }

    func section(at sectionNumber: Int) -> NSCollectionLayoutSection {
        if sectionNumber == 0 {
            return self.pupularSearchTermLayout
        } else {
            return self.challengeLayout
        }
    }
}
