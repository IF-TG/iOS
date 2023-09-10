//
//  SearchLayout.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/07/20.
//

import UIKit

protocol SearchLayout {
  func createLayout() -> UICollectionViewCompositionalLayout
}

// MARK: - SearchCompositionalLayout
class DefaultSearchLayout: SearchLayout {
  func createLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
      switch sectionIndex {
      case SearchSectionType.festival.rawValue: return self?.firstSectionLayout()
      case SearchSectionType.famous.rawValue: return self?.secondSectionLayout()
      default: return nil
      }
    }
  }
}

// MARK: - Helpers
extension DefaultSearchLayout {
  private func firstSectionLayout() -> NSCollectionLayoutSection {
    let item = makeLayoutItem(
      fractionalWidth: Constants.Festival.Item.fractionalWidth,
      fractionalHeight: Constants.Festival.Item.fractionalHeight
    )
    
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: .init(
        widthDimension: .absolute(Constants.Festival.Group.width),
        heightDimension: .absolute(Constants.Festival.Group.height)
      ),
      subitems: [item]
    )
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .continuous
    section.interGroupSpacing = Constants.Festival.Section.interGroupSpacing
    section.contentInsets = .init(
      top: Constants.Festival.Section.Inset.top,
      leading: Constants.Festival.Section.Inset.leading,
      bottom: Constants.Festival.Section.Inset.bottom,
      trailing: Constants.Festival.Section.Inset.trailing
    )
    section.boundarySupplementaryItems = [headerLayout()]
    return section
  }
  
  private func secondSectionLayout() -> NSCollectionLayoutSection {
    let item = makeLayoutItem(
      fractionalWidth: Constants.Famous.Item.fractionalWidth,
      fractionalHeight: Constants.Famous.Item.fractionalHeight
    )
    
    let group = NSCollectionLayoutGroup.vertical(
      layoutSize: .init(
        widthDimension: .fractionalWidth(Constants.Famous.Group.fractionalWidth),
        heightDimension: .absolute(Constants.Famous.Group.height)
      ),
      subitem: item,
      count: 3
    )
    group.interItemSpacing = .fixed(Constants.Famous.Group.interSpacing)
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .groupPaging
    section.interGroupSpacing = Constants.Famous.Section.interGroupSpacing
    section.contentInsets = .init(
      top: Constants.Famous.Section.Inset.top,
      leading: Constants.Famous.Section.Inset.leading,
      bottom: Constants.Famous.Section.Inset.bottom,
      trailing: Constants.Famous.Section.Inset.trailing
    )
    section.boundarySupplementaryItems = [headerLayout()]
    
    return section
  }
  
  private func headerLayout() -> NSCollectionLayoutBoundarySupplementaryItem {
    return .init(
      layoutSize: .init(
        widthDimension: .fractionalWidth(Constants.Header.fractionalWidth),
        heightDimension: .estimated(Constants.Header.estimatedHeight)
      ),
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .top
    )
  }
  
  private func makeLayoutItem(
    fractionalWidth: CGFloat,
    fractionalHeight: CGFloat
  ) -> NSCollectionLayoutItem {
    return NSCollectionLayoutItem(layoutSize: .init(
      widthDimension: .fractionalWidth(fractionalWidth),
      heightDimension: .fractionalHeight(fractionalHeight)
    ))
  }
}
