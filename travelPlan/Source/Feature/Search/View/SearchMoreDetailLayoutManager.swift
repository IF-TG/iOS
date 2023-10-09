//
//  SearchMoreDetailLayoutManager.swift
//  travelPlan
//
//  Created by SeokHyun on 10/6/23.
//

import UIKit

class SearchMoreDetailLayoutManager: CompositionalLayoutCreatable {
  func makeLayout() -> UICollectionViewCompositionalLayout {
    return .init { [weak self] sectionIndex, _ in
      switch sectionIndex {
      case .zero:
        return self?.makeFirstSectionLayout()
      default:
        return nil
      }
    }
  }
}

// MARK: - Private Helpers
extension SearchMoreDetailLayoutManager {
  private func makeFirstSectionLayout() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                          heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                           heightDimension: .absolute(140))
    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = .init(top: 8, leading: 16, bottom: .zero, trailing: .zero)

    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                            heightDimension: .fractionalHeight(0.27))
    let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerSize,
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .top
    )
    section.boundarySupplementaryItems = [sectionHeader]
    
    return section
  }
}
