//
//  SearchCompositionalLayout.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/07/20.
//

import UIKit

class SearchCompositionalLayout {
  enum Constants {
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
    enum Famous {
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

extension SearchCompositionalLayout: CompositionalLayoutCreatable {
  func makeLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
      switch sectionIndex {
      case SearchSectionType.festival.rawValue: return self?.festivalSectionLayout()
      case SearchSectionType.camping.rawValue: return self?.campingSectionLayout()
      default: return nil
      }
    }
  }
}

// MARK: - Helpers
extension SearchCompositionalLayout {
  private func festivalSectionLayout() -> NSCollectionLayoutSection {
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
      top: .zero,
      leading: Constants.Festival.Section.Inset.leading,
      bottom: .zero,
      trailing: Constants.Festival.Section.Inset.trailing
    )
    section.boundarySupplementaryItems = [headerLayout()]
    return section
  }
  
  private func campingSectionLayout() -> NSCollectionLayoutSection {
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
      count: Constants.Famous.Group.count
    )
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .groupPaging
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
