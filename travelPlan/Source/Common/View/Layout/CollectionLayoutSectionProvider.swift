//
//  CollectionLayoutSectionProvider.swift
//  travelPlan
//
//  Created by SeokHyun on 5/25/24.
//

import Foundation
import UIKit.UICollectionView

class CollectionLayoutSectionProvider {
  private init() { }
  
  static func createOneLineTagSection() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .estimated(50),
      heightDimension: .absolute(30)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .estimated(50),
      heightDimension: .absolute(30)
    )
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = 8
    section.contentInsets = .init(
      top: 8,
      leading: 20,
      bottom: 8,
      trailing: 20
    )
    section.orthogonalScrollingBehavior = .continuous
    
    return section
  }
}
