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
      case SearchSectionType.leports.rawValue:
        return self?.leportsLayout()
      default: return nil
      }
    }
  }
}

// MARK: - Helpers
extension MainSearchLayoutManager {
  private func festivalLayout() -> NSCollectionLayoutSection {
    let item = makeLayoutItem(
      fractionalWidth: Constant.Festival.Item.fractionalWidth,
      fractionalHeight: Constant.Festival.Item.fractionalHeight
    )
    
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: .init(
        widthDimension: .absolute(Constant.Festival.Group.width),
        heightDimension: .absolute(Constant.Festival.Group.height)
      ),
      subitems: [item]
    )
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .continuous
    section.interGroupSpacing = Constant.Festival.Section.interGroupSpacing
    section.contentInsets = .init(
      top: .zero,
      leading: Constant.Festival.Section.Inset.leading,
      bottom: .zero,
      trailing: Constant.Festival.Section.Inset.trailing
    )
    section.boundarySupplementaryItems = [headerLayout()]
    return section
  }
  
  private func leportsLayout() -> NSCollectionLayoutSection {
    let item = makeLayoutItem(
      fractionalWidth: Constant.Camping.Item.fractionalWidth,
      fractionalHeight: Constant.Camping.Item.fractionalHeight
    )
    
    let group = NSCollectionLayoutGroup.vertical(
      layoutSize: .init(
        widthDimension: .fractionalWidth(Constant.Camping.Group.fractionalWidth),
        heightDimension: .absolute(Constant.Camping.Group.height)
      ),
      subitem: item,
      count: Constant.Camping.Group.count
    )
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .groupPaging
    section.contentInsets = .init(
      top: Constant.Camping.Section.Inset.top,
      leading: Constant.Camping.Section.Inset.leading,
      bottom: Constant.Camping.Section.Inset.bottom,
      trailing: Constant.Camping.Section.Inset.trailing
    )
    section.boundarySupplementaryItems = [headerLayout()]
    return section
  }
  
  private func headerLayout() -> NSCollectionLayoutBoundarySupplementaryItem {
    return .init(
      layoutSize: .init(
        widthDimension: .fractionalWidth(Constant.Header.fractionalWidth),
        heightDimension: .estimated(Constant.Header.estimatedHeight)
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
