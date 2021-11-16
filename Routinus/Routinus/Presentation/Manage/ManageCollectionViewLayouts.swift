//
//  ManageCollectionViewLayouts.swift
//  Routinus
//
//  Created by 김민서 on 2021/11/12.
//

import UIKit

class ManageCollectionViewLayouts {
    private var challengeLayout: NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .estimated(140))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(140))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(20)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.contentInsets = .init(top: 10, leading: 25, bottom: 10, trailing: 25)
        section.interGroupSpacing = 30
        return section
    }

    func section(at sectionNumber: Int) -> NSCollectionLayoutSection {
        return self.challengeLayout
    }
}
