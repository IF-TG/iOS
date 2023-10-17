//
//  SearchMoreDetailLayoutManager.swift
//  travelPlan
//
//  Created by SeokHyun on 10/6/23.
//

import UIKit

class SearchMoreDetailLayoutManager: CompositionalLayoutCreatable {
  enum Constant {
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
        static let top: CGFloat = headerViewSectionViewSpacing + sectionViewCellSpacing
      }
    }
    enum Header {
      static let fractionWidth: CGFloat = 1
      static let height: CGFloat = 200
    }
    enum SectionBackgroundView {
      enum ContentInsets {
        static let top: CGFloat = Constant.Header.height + headerViewSectionViewSpacing
      }
    }
    static let headerViewSectionViewSpacing: CGFloat = 16
    static let sectionViewCellSpacing: CGFloat = 8
  }
  
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
  private func makeSectionLayout() -> NSCollectionLayoutSection {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(Constant.Item.fractionWidth),
                                          heightDimension: .fractionalHeight(Constant.Item.fractionHeight))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(Constant.Group.fractionWidth),
                                           heightDimension: .absolute(Constant.Group.height))
    let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
    group.contentInsets = .init(top: .zero,
                                leading: Constant.Group.ContentInsets.leading,
                                bottom: .zero,
                                trailing: .zero)
    
    let section = NSCollectionLayoutSection(group: group)
    section.contentInsets = .init(top: Constant.Section.ContentInsets.top,
                                  leading: .zero,
                                  bottom: .zero,
                                  trailing: .zero)
    let sectionBackgroundView = NSCollectionLayoutDecorationItem
      .background(elementKind: InnerRoundRectReusableView.id)
    sectionBackgroundView.contentInsets = .init(top: Constant.SectionBackgroundView.ContentInsets.top,
                                                leading: .zero,
                                                bottom: .zero,
                                                trailing: .zero)
    section.decorationItems = [sectionBackgroundView]
    
    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(Constant.Header.fractionWidth),
                                            heightDimension: .absolute(Constant.Header.height))
    let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: headerSize,
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .top
    )
    section.boundarySupplementaryItems = [sectionHeader]
    
    return section
  }
}
