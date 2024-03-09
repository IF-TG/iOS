//
//  SearchDestinationCollectionViewLayout.swift
//  travelPlan
//
//  Created by SeokHyun on 11/29/23.
//

import UIKit

final class SearchDestinationCollectionViewLayout: CompositionalLayoutCreatable {
  func makeLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout { [weak self] section, _ in
      switch section {
      case 0:
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .estimated(95))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(95))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 10, leading: 20, bottom: 0, trailing: 20)
        return section
      case 1:
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(91))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        // TODO: - inset 제거하고 요구사항에 맞게 수정하기
        section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
        return section
      case 2:
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .estimated(150))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(150))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        // TODO: - inset 제거하고 요구사항에 맞게 수정하기
        section.contentInsets = .init(top: 0, leading: 40, bottom: 0, trailing: 40)
        section.interGroupSpacing = 20
        return section
      default:
        return nil
      }
    }
  }
}

// MARK: - Private Helpers
extension SearchDestinationCollectionViewLayout {
//  private func firstSectionLayout() -> NSCollectionLayoutSection {
//    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
//                                          heightDimension: .estimated(95))
//    let item = NSCollectionLayoutItem(layoutSize: itemSize)
//    
//    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
//                                           heightDimension: .estimated(95))
//    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
//    
//    let section = NSCollectionLayoutSection(group: group)
//    section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
//    return section
//  }
//  
//  private func secondSectionLayout() -> NSCollectionLayoutSection {
//    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
//                                          heightDimension: .fractionalHeight(1))
//    let item = NSCollectionLayoutItem(layoutSize: itemSize)
//    
//    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
//                                           heightDimension: .absolute(90))
//    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
//    
//    let section = NSCollectionLayoutSection(group: group)
//    return section
//  }
}
