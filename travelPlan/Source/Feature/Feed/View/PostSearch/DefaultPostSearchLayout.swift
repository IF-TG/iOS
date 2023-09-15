//
//  DefaultPostSearchLayout.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/09/04.
//

import UIKit

// MARK: - PostSearchLayout
class DefaultPostSearchLayout: PostSearchLayout {
  enum Constants {
    enum Recommendation {
      enum Item {
        static let estimatedWidth: CGFloat = 50
        static let absoluteHeight: CGFloat = 30
      }
      enum Group {
        static let estimatedWidth: CGFloat = 50
        static let absoluteHeight: CGFloat = 30
      }
      enum Section {
        static let interGroupSpacing: CGFloat = 8
        enum ContentInset {
          static let top: CGFloat = 8
          static let leading: CGFloat = 20
          static let bottom: CGFloat = 8
          static let trailing: CGFloat = 20
        }
      }
    }
    
    enum Recent {
      enum Item {
        static let estimatedWidth: CGFloat = 50
        static let absoluteHeight: CGFloat = 30
      }
      enum Group {
        static let fractionalWidth: CGFloat = 1.0
        static let absoluteHeight: CGFloat = 30
        static let interItemSpacing: CGFloat = 8
      }
      enum Section {
        static let interGroupSpacing: CGFloat = 16
        enum ContentInsets {
          static let top: CGFloat = 8
          static let leading: CGFloat = 20
          static let bottom: CGFloat = 8
          static let trailing: CGFloat = 20
        }
      }
    }
    
    enum Header {
      static let fractionalWidth: CGFloat = 1.0
      static let absoluteHeight: CGFloat = 60
    }
    enum Footer {
      static let fractionalWidth: CGFloat = 1.0
      static let absoluteHeight: CGFloat = 21
    }
  }
  
  func createLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout { [weak self] section, _ in
      switch section {
      case PostSearchSection.recommendation.rawValue:
        return self?.recommendationSearchSectionLayout()
      case PostSearchSection.recent.rawValue:
        return self?.recentSearchSectionLayout()
      default: return nil
      }
    }
  }
}

// MARK: - Helpers
extension DefaultPostSearchLayout {
  private func recommendationSearchSectionLayout() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .estimated(Constants.Recommendation.Item.estimatedWidth),
      heightDimension: .absolute(Constants.Recommendation.Item.absoluteHeight)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .estimated(Constants.Recommendation.Group.estimatedWidth),
      heightDimension: .absolute(Constants.Recommendation.Group.absoluteHeight)
    )
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = Constants.Recommendation.Section.interGroupSpacing
    section.contentInsets = .init(
      top: Constants.Recommendation.Section.ContentInset.top,
      leading: Constants.Recommendation.Section.ContentInset.leading,
      bottom: Constants.Recommendation.Section.ContentInset.bottom,
      trailing: Constants.Recommendation.Section.ContentInset.trailing
    )
    section.orthogonalScrollingBehavior = .continuous
    
    section.boundarySupplementaryItems = [createHeaderViewLayout(), createRecommendationFooterViewLayout()]
    return section
  }
  
  private func recentSearchSectionLayout() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .estimated(Constants.Recent.Item.estimatedWidth),
      heightDimension: .absolute(Constants.Recent.Item.absoluteHeight)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)

    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(Constants.Recent.Group.fractionalWidth),
      heightDimension: .absolute(Constants.Recent.Group.absoluteHeight)
    )
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    group.interItemSpacing = .fixed(Constants.Recent.Group.interItemSpacing)

    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = Constants.Recent.Section.interGroupSpacing
    section.contentInsets = .init(
      top: Constants.Recent.Section.ContentInsets.top,
      leading: Constants.Recent.Section.ContentInsets.leading,
      bottom: Constants.Recent.Section.ContentInsets.bottom,
      trailing: Constants.Recent.Section.ContentInsets.trailing
    )
    section.boundarySupplementaryItems = [createHeaderViewLayout()]
    
    return section
  }
  
  private func createHeaderViewLayout() -> NSCollectionLayoutBoundarySupplementaryItem {
    let headerSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(Constants.Header.fractionalWidth),
      heightDimension: .absolute(Constants.Header.absoluteHeight)
    )
    let header = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerSize,
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .top
    )
    
    return header
  }
  
  private func createRecommendationFooterViewLayout() -> NSCollectionLayoutBoundarySupplementaryItem {
    let footerSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(Constants.Footer.fractionalWidth),
      heightDimension: .absolute(Constants.Footer.absoluteHeight)
    )
    let footer = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: footerSize,
      elementKind: UICollectionView.elementKindSectionFooter,
      alignment: .bottom
    )
    
    return footer
  }
}
