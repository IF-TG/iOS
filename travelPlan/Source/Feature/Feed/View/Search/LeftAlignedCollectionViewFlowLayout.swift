//
//  LeftAlignedCollectionViewFlowLayout.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/10.
//

import UIKit

final class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
  // MARK: - LifeCycle
  override init() {
    super.init()
    setupReferenceSize()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    guard let attributes = super.layoutAttributesForElements(in: rect) else { return [] }
    
    var leftMargin = sectionInset.left
    var maxY: CGFloat = -1.0
    let edgeInset: CGFloat = 20
    
    guard let collectionView = collectionView else { return nil }
    
    // 원본 객체가 아닌, copy 객체 사용
    let copyAttributes = attributes.map {
      guard let copyAttribute = $0.copy() as? UICollectionViewLayoutAttributes
      else { return UICollectionViewLayoutAttributes() }
      
      return copyAttribute
    }
    
    copyAttributes
      .filter { $0.representedElementCategory == .cell }
      .forEach {
        if $0.frame.width >= collectionView.frame.width - (edgeInset * 2) {
          $0.frame.size.width = collectionView.frame.width - (edgeInset * 2)
        }
        
        if $0.frame.origin.y >= maxY {
          leftMargin = sectionInset.left
        }
        
        $0.frame.origin.x = leftMargin
        leftMargin += $0.frame.width + minimumInteritemSpacing
        maxY = max($0.frame.maxY, maxY)
      }

    return copyAttributes
  }
}

// MARK: - Helpers
extension LeftAlignedCollectionViewFlowLayout {
  private func setupReferenceSize() {
    headerReferenceSize = CGSize(
      width: UIScreen.main.bounds.size.width,
      height: 60
    )
    footerReferenceSize = CGSize(
      width: UIScreen.main.bounds.size.width,
      height: 21
    )
  }
}
