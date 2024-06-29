//
//  CompositionalSectionLayoutBuilder.swift
//  travelPlan
//
//  Created by 양승현 on 6/28/24.
//

import UIKit

public struct CollectionLayoutSize {
  let width: NSCollectionLayoutDimension
  let height: NSCollectionLayoutDimension
  
  fileprivate func asNSCollectionLayoutSize() -> NSCollectionLayoutSize {
    return NSCollectionLayoutSize(widthDimension: width, heightDimension: height)
  }
}

/// 간단하게 size를 지정하고, configure 함수를 통해 layout item, gorup, section의  속성을 설정해서 Section을 build합니다.
///
/// Examples: default to use builder's flow
/// ```
/// NSCollectionLayoutGroup.builder()
///   .setItemSize(.init(width: .fractionWidth(1), height: .fractionHeight(1)))
///   .setGroupSize(.init(width: .fractionWidth(1), height: .fractionHeight(1)))
///   .setGroupStyle(.horizontal)
///   .build()
/// ```
///
/// 위 예시에서 build()호출 전에 item, group instance에 부가적인 attributes(e.g. contentInset, spacing, header, footer etc...)를 주어아 햔다면
/// - configureItem(_:), configureGroup(_:) 를 호출하세요.
/// - Section에 대한 backgroundview 등 attributes를 호출하려면 build() 이후 set을 통해 설정할 수 있습니다.
public class CompositionalSectionLayoutBuilder {
  public typealias makeSubItems = (CompositionalSectionLayoutBuilder) -> [NSCollectionLayoutItem]
  
  @frozen public enum GroupStyle {
    case vertial
    case horizontal
  }
  
  // MARK: - Properties
  private(set) var itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
    widthDimension: .fractionalWidth(1.0),
    heightDimension: .fractionalHeight(1.0))
  
  private(set) var groupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(
    widthDimension: .fractionalWidth(1.0),
    heightDimension: .fractionalHeight(1.0))
  
  private(set) var item: NSCollectionLayoutItem!
  
  private(set) var group: NSCollectionLayoutGroup!
  
  private var orthogonalScrollingBehavior: UICollectionLayoutSectionOrthogonalScrollingBehavior = .none
  
  // MARK: - Helpers
  public func setItemSize(_ size: CollectionLayoutSize) -> Self {
    self.itemSize = size.asNSCollectionLayoutSize()
    item = NSCollectionLayoutItem(layoutSize: itemSize)
    return self
  }
  
  public func setGroupSize(_ size: CollectionLayoutSize) -> Self {
    self.groupSize = size.asNSCollectionLayoutSize()
    return self
  }
  
  public func setOrthogonalScrollingBehavior(
    _ behavior: UICollectionLayoutSectionOrthogonalScrollingBehavior
  ) -> Self {
    self.orthogonalScrollingBehavior = behavior
    return self
  }
  
  /// Group의 arranged state를 지정해야합니다. 그렇지 않을 경우 기본값 horizontal로 지정됩니다.
  /// makeSubItems를 통해 직접 subites를 지정할 수 있습니다.
  ///   CompositionalSectionLayoutBuilder에 반영된 ItemSize 등을 참조해서 SubItem을 직접 만들 수도 있습니다.
  public func setGroupStyle(_ groupStyle: GroupStyle, makeSubitems: makeSubItems? = nil) -> Self {
    if item == nil {
      item = NSCollectionLayoutItem(layoutSize: itemSize)
    }
    switch groupStyle {
    case .vertial:
      group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: makeSubitems?(self) ?? [item])
    case .horizontal:
      group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: makeSubitems?(self) ?? [item])
    }
    return self
  }
  
  // MARK: - Configure Helpers
  public func configureItem(_ config: (NSCollectionLayoutItem) -> Void) -> Self {
    if item == nil {
      item = NSCollectionLayoutItem(layoutSize: itemSize)
    }
    config(item)
    return self
  }
  
  public func configureGoup(_ config: (NSCollectionLayoutGroup) -> Void) -> Self {
    if group == nil {
      group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    }
    config(group)
    return self
  }
  
  public func build() -> NSCollectionLayoutSection {
    if item == nil {
      item = NSCollectionLayoutItem(layoutSize: itemSize)
    }
    if group == nil {
      group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    }
    return NSCollectionLayoutSection(group: group)
  }
}

extension NSCollectionLayoutSection {
  typealias Builder = CompositionalSectionLayoutBuilder
}
