//
//  ManageCollectionViewLayouts.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/12.
//

import UIKit

final class ManageCollectionViewLayouts {
    private var challengeLayout: NSCollectionLayoutSection {
        let smallWidth = UIScreen.main.bounds.width <= 350
        let offset = smallWidth ? 15.0 : 25.0

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .estimated(140))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(140))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: 2)
        group.interItemSpacing = .fixed(20)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.contentInsets = .init(top: 10, leading: offset, bottom: 10, trailing: offset)
        section.interGroupSpacing = 30
        return section
    }

    func section(at sectionNumber: Int) -> NSCollectionLayoutSection {
        return self.challengeLayout
    }
}
