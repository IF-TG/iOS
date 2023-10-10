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
        return self?.makeSectionLayout()
      default:
        return nil
      }
    }
  }
}

// MARK: - Private Helpers
extension SearchMoreDetailLayoutManager {
  enum Constants {
    enum Item {
      static let fractionWidth: CGFloat = 1
      static let fractionHeight: CGFloat = 1
    }
    enum Group {
      static let fractionWidth: CGFloat = 1
      static let height: CGFloat = 140
      enum ContentInsets {
        static let leading: CGFloat = 16
      }
    }
    enum Section {
      enum ContentInsets {
        static let top: CGFloat = 16
      }
    }
    enum Header {
      static let fractionWidth: CGFloat = 1
      static let fractionHeight: CGFloat = 0.275
    }
  }
  
  private func makeSectionLayout() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(Constants.Item.fractionWidth),
                                          heightDimension: .fractionalHeight(Constants.Item.fractionHeight))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(Constants.Group.fractionWidth),
                                           heightDimension: .absolute(Constants.Group.height))
    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
    group.contentInsets = .init(top: .zero,
                                leading: Constants.Group.ContentInsets.leading,
                                bottom: .zero,
                                trailing: .zero)
    
    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = .init(top: Constants.Section.ContentInsets.top,
                                  leading: .zero,
                                  bottom: .zero,
                                  trailing: .zero)

    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(Constants.Header.fractionWidth),
                                            heightDimension: .fractionalHeight(Constants.Header.fractionHeight))
    let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerSize,
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .top
    )
    section.boundarySupplementaryItems = [sectionHeader]
    
    return section
  }
}
