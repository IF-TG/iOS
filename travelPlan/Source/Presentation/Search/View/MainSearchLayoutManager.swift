//
//  MainSearchLayoutManager.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/07/20.
//

import UIKit

class MainSearchLayoutManager {
  enum Constant {
    // MARK: - First
    enum Festival {
      enum Item {
        static let fractionalWidth: CGFloat = 1
        static let fractionalHeight: CGFloat = 1
      }
      enum Group {
        static let width: CGFloat = 140
        static let height: CGFloat = 150
      }
      enum Section {
        static let interGroupSpacing: CGFloat = 10
        enum Inset {
          static let leading: CGFloat = 16
          static let trailing: CGFloat = 16
        }
      }
    }
    
    // MARK: - Second
    enum Camping {
      enum Item {
        static let fractionalWidth: CGFloat = 1
        static let fractionalHeight: CGFloat = 0.3
      }
      enum Group {
        static let fractionalWidth: CGFloat = 0.89
        static let height: CGFloat = 360
        static let count = 3
      }
      enum Section {
        enum Inset {
          static let leading: CGFloat = 16
          static let trailing: CGFloat = 16
          static let top: CGFloat = 5
          static let bottom: CGFloat = 5
        }
      }
    }
    
    enum Header {
      static let fractionalWidth: CGFloat = 1.0
      static let estimatedHeight: CGFloat = 74
    }
  }
}

extension MainSearchLayoutManager: CompositionalLayoutCreatable {
  func makeLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
      switch sectionIndex {
      case SearchSectionType.festival.rawValue: 
        return self?.festivalLayout()
        
      case SearchSectionType.leports.rawValue, SearchSectionType.cultureFacility.rawValue:
        return self?.commonLayout()
      default: return nil
      }
    }
  }
}

// MARK: - Helpers
extension MainSearchLayoutManager {
  private func festivalLayout() -> NSCollectionLayoutSection {
    let item = makeLayoutItem(
      fractionalWidth: 1,
      fractionalHeight: 1
    )
    
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
    section.contentInsets = .init(
      top: .zero,
      leading: 16,
      bottom: .zero,
      trailing: 16
    )
    section.boundarySupplementaryItems = [headerLayout()]
    return section
  }
  
  private func commonLayout() -> NSCollectionLayoutSection {
    let item = makeLayoutItem(
      fractionalWidth: 1,
      fractionalHeight: 0.3
    )
    
    let group = NSCollectionLayoutGroup.vertical(
      layoutSize: .init(
        widthDimension: .fractionalWidth(0.89),
        heightDimension: .absolute(360)
      ),
      subitem: item,
      count: 3
    )
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .groupPaging
    section.contentInsets = .init(
      top: 5,
      leading: 16,
      bottom: 5,
      trailing: 16
    )
    section.boundarySupplementaryItems = [headerLayout()]
    return section
  }
  
  private func headerLayout() -> NSCollectionLayoutBoundarySupplementaryItem {
    return .init(
      layoutSize: .init(
        widthDimension: .fractionalWidth(1.0),
        heightDimension: .estimated(74)
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
