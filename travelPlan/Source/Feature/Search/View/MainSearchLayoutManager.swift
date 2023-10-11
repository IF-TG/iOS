//
//  MainSearchLayoutManager.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/07/20.
//

import UIKit

class MainSearchLayoutManager {
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
    
    enum TopTen {
      enum Item {
        static let fractionalWidth: CGFloat = 1
        static let fractionalHeight: CGFloat = 1
      }
      enum Group {
        static let fractionWidth: CGFloat = 1
        static let height: CGFloat = 120
      }
      enum Section {
        enum ContentInsets {
          static let top: CGFloat = 0
          static let leading: CGFloat = 16
          static let trailing: CGFloat = 12
          static let bottom: CGFloat = 0
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
      case SearchSectionType.camping.rawValue: 
        return self?.campingLayout()
      case SearchSectionType.topTen.rawValue:
        return self?.topTenLayout()
      default: return nil
      }
    }
  }
}

// MARK: - Helpers
extension MainSearchLayoutManager {
  private func festivalLayout() -> NSCollectionLayoutSection {
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
  
  private func campingLayout() -> NSCollectionLayoutSection {
    let item = makeLayoutItem(
      fractionalWidth: Constants.Camping.Item.fractionalWidth,
      fractionalHeight: Constants.Camping.Item.fractionalHeight
    )
    
    let group = NSCollectionLayoutGroup.vertical(
      layoutSize: .init(
        widthDimension: .fractionalWidth(Constants.Camping.Group.fractionalWidth),
        heightDimension: .absolute(Constants.Camping.Group.height)
      ),
      subitem: item,
      count: Constants.Camping.Group.count
    )
    
    let section = NSCollectionLayoutSection(group: group)
    section.orthogonalScrollingBehavior = .groupPaging
    section.contentInsets = .init(
      top: Constants.Camping.Section.Inset.top,
      leading: Constants.Camping.Section.Inset.leading,
      bottom: Constants.Camping.Section.Inset.bottom,
      trailing: Constants.Camping.Section.Inset.trailing
    )
    section.boundarySupplementaryItems = [headerLayout()]
    return section
  }
  
  private func topTenLayout() -> NSCollectionLayoutSection {
    typealias Cnst = Constants.TopTen
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(Cnst.Item.fractionalWidth),
                                          heightDimension: .fractionalHeight(Cnst.Item.fractionalHeight))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(Cnst.Group.fractionWidth),
                                           heightDimension: .absolute(Cnst.Group.height))
    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize,
                                                 subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = .init(top: Cnst.Section.ContentInsets.top,
                                  leading: Cnst.Section.ContentInsets.leading,
                                  bottom: Cnst.Section.ContentInsets.bottom,
                                  trailing: Cnst.Section.ContentInsets.trailing)
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
