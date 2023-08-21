//
//  SearchCollectionViewCompositionalLayout.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/07/20.
//

import UIKit

class SearchCollectionViewCompositionalLayout {
  
}

// MARK: - SearchCompositionalLayout
extension SearchCollectionViewCompositionalLayout: SearchCompositionalLayout {
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
extension SearchCollectionViewCompositionalLayout {
  private func firstSectionLayout() -> NSCollectionLayoutSection {
    let item = makeLayoutItem(
      fractionalWidth: Constants.Festival.Item.width,
      fractionalHeight: Constants.Festival.Item.height
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
    section.boundarySupplementaryItems = [self.supplementaryHeaderItem()] // 헤더의 layout 처리
    // availableTODO: - 16버전은 사용 불가능, 버전에 따라 처리 해주어야 합니다.
    section.supplementariesFollowContentInsets = false // false의 경우, item의 contentInset을 무시하고 size 설정
    return section
  }
  
  private func secondSectionLayout() -> NSCollectionLayoutSection {
    let item = makeLayoutItem(
      fractionalWidth: Constants.Famous.Item.width,
      fractionalHeight: Constants.Famous.Item.height
    )
    
    let group = NSCollectionLayoutGroup.vertical(
      layoutSize: .init(
        widthDimension: .fractionalWidth(Constants.Famous.Group.width),
        heightDimension: .absolute(Constants.Famous.Group.height)
      ),
      subitems: [item]
    )
    group.interItemSpacing = .fixed(Constants.Famous.Group.interSpacing)
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .groupPaging
    section.interGroupSpacing = Constants.Famous.Section.interSpacing
    section.contentInsets = .init(
      top: Constants.Famous.Section.Inset.top,
      leading: Constants.Famous.Section.Inset.leading,
      bottom: Constants.Famous.Section.Inset.bottom,
      trailing: Constants.Famous.Section.Inset.trailing
    )
    section.boundarySupplementaryItems = [self.supplementaryHeaderItem()] // 헤더의 layout 처리
    section.supplementariesFollowContentInsets = false
    
    return section
  }
  private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
    return .init(
      layoutSize: .init(
        widthDimension: .fractionalWidth(Constants.Header.width),
        heightDimension: .estimated(Constants.Header.height)
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
