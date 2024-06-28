//
//  CompositionalSectionLayoutBuilder.swift
//  travelPlan
//
//  Created by 양승현 on 6/28/24.
//

import UIKit

/// 간단하게 size를 지정하고, configure 함수를 통해 layout item, gorup, section의  속성을 설정해서 Section을 build합니다.
public class CompositionalSectionLayoutBuilder {
  // MARK: - Properties
  private lazy var itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
    widthDimension: .fractionalWidth(1.0),
    heightDimension: .fractionalHeight(1.0))
  
  private lazy var groupSize: NSCollectionLayoutSize = itemSize
  
  private lazy var item: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
  
  private lazy var group: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(
    layoutSize: groupSize, subitems: [item])
  
  private lazy var section: NSCollectionLayoutSection  = NSCollectionLayoutSection(group: group)
  
  private var orthogonalScrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior = .none
  
  // MARK: - Helpers
  public func setItemSize(_ size: NSCollectionLayoutSize) -> Self {
    self.itemSize = size
    return self
  }
  
  public func setGroupSize(_ size: NSCollectionLayoutSize) -> Self {
    self.groupSize = size
    return self
  }
  
  public func setOrthogonalScrollingBehavior(_ behavior: UICollectionLayoutSectionOrthogonalScrollingBehavior) -> Self {
    self.orthogonalScrollingBehavior = behavior
    return self
  }
  
  // MARK: - Configure Helpers
  public func configureItem(_ config: (NSCollectionLayoutItem) -> Void) -> Self {
    config(item)
    return self
  }
  
  public func configureGoup(_ config: (NSCollectionLayoutGroup) -> Void) -> Self {
    config(group)
    return self
  }
  
  public func build() -> NSCollectionLayoutSection {
    return section
  }
}

extension NSCollectionLayoutSection {
  typealias Builder = CompositionalSectionLayoutBuilder
}
