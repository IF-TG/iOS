//
//  TravelDestinationLayoutGroupProvider.swift
//  travelPlan
//
//  Created by SeokHyun on 5/24/24.
//

import UIKit.UICollectionView

class TravelDestinationLayoutGroupProvider {
  private init() { }
  
  static func createDefaultGroup() -> NSCollectionLayoutGroup {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                          heightDimension: .fractionalHeight(1))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                           heightDimension: .absolute(140))
    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
    group.contentInsets = .init(top: .zero,
                                leading: 16,
                                bottom: .zero,
                                trailing: .zero)
  }
}
