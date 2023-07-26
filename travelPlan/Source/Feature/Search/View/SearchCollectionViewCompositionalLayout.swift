//
//  SearchCollectionViewCompositionalLayout.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/07/20.
//

import UIKit

class SearchCollectionViewCompositionalLayout {
  enum SearchSection: Int {
    case festival
    case famous
  }
}

// MARK: - SearchCompositionalLayout
extension SearchCollectionViewCompositionalLayout: SearchCompositionalLayout {
  func createLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
      switch sectionIndex {
      case SearchSection.festival.rawValue: return self?.firstSectionLayout()
      case SearchSection.famous.rawValue: return self?.secondSectionLayout()
      default: return nil
      }
    }
  }
}

// MARK: - Helpers
extension SearchCollectionViewCompositionalLayout {
  private func firstSectionLayout() -> NSCollectionLayoutSection {
    let item = makeLayoutItem(fractionalWidth: 1, fractionalHeight: 1)
    
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: .init(
        widthDimension: .absolute(140),
        heightDimension: .absolute(150)
      ),
      subitems: [item]
    )
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .continuous
    section.interGroupSpacing = 10
    section.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 20)
    section.boundarySupplementaryItems = [self.supplementaryHeaderItem()] // 헤더의 layout 처리
    // availableTODO: - 16버전은 사용 불가능, 버전에 따라 처리 해주어야 합니다.
    section.supplementariesFollowContentInsets = false // false의 경우, item의 contentInset을 무시하고 size 설정
    return section
  }
  
  private func secondSectionLayout() -> NSCollectionLayoutSection {
    let item = makeLayoutItem(fractionalWidth: 1, fractionalHeight: 0.3)
    
    let group = NSCollectionLayoutGroup.vertical(
      layoutSize: .init(
        widthDimension: .fractionalWidth(0.87),
        heightDimension: .absolute(360)
      ),
      subitems: [item]
    )
    group.interItemSpacing = .fixed(10)
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .groupPaging
    section.interGroupSpacing = 20
    section.contentInsets = .init(
      top: 5,
      leading: 0,
      bottom: 5,
      trailing: UIScreen.main.bounds.size.width * 0.13
    )
    section.boundarySupplementaryItems = [self.supplementaryHeaderItem()] // 헤더의 layout 처리
    section.supplementariesFollowContentInsets = false
    
    return section
  }
  
  private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
    return .init(
      layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(74)),
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .top
    )
  }
  
  private func makeLayoutItem(fractionalWidth: CGFloat, fractionalHeight: CGFloat) -> NSCollectionLayoutItem {
    return NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(fractionalWidth),
                                                    heightDimension: .fractionalHeight(fractionalHeight)))
  }
}
