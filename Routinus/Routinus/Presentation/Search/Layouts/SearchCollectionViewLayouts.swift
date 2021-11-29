//
//  SearchCollectionViewLayouts.swift
//  Routinus
//
//  Created by 박상우 on 2021/11/09.
//

import UIKit

final class SearchCollectionViewLayouts {
    private var pupularSearchKeywordLayout: NSCollectionLayoutSection {
        let smallWidth = UIScreen.main.bounds.width <= 350
        let offset = smallWidth ? 15.0 : 20.0

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.17),
                                               heightDimension: .estimated(30))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [.init(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading
        )]
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = .init(top: 5, leading: offset, bottom: 20, trailing: offset)
        section.interGroupSpacing = 20
        return section
    }

    private var challengeLayout: NSCollectionLayoutSection {
        let smallWidth = UIScreen.main.bounds.width <= 350
        let offset = smallWidth ? 15.0 : 20.0

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .estimated(140))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(140))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: 2)
        group.interItemSpacing = .fixed(15)

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [.init(
            layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)),
            elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading
        )]
        section.orthogonalScrollingBehavior = .none
        section.contentInsets = .init(top: 10, leading: offset, bottom: 10, trailing: offset)
        section.interGroupSpacing = 30
        return section
    }

    func section(at sectionNumber: Int) -> NSCollectionLayoutSection {
        if sectionNumber == 0 {
            return pupularSearchKeywordLayout
        } else {
            return challengeLayout
        }
    }
}
