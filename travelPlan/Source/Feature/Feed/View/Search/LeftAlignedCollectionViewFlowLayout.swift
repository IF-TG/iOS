//
//  LeftAlignedCollectionViewFlowLayout.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/10.
//

import UIKit

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
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
    
    var leftMargin = self.sectionInset.left
    var maxY: CGFloat = -1.0
    let edgeInset: CGFloat = 20
    
    // copy 객체 customizing 후, return
    let copyAttributes = attributes.map {
      if let copyAttribute = $0.copy() as? UICollectionViewLayoutAttributes {
        return copyAttribute
      }
      return UICollectionViewLayoutAttributes()
    }
    
    copyAttributes.forEach { layoutAttribute in
      if layoutAttribute.representedElementCategory == .cell {
        
        guard let collectionView = self.collectionView else { return }
        
        if layoutAttribute.frame.width >= collectionView.frame.width - (edgeInset * 2) {
          layoutAttribute.frame.size.width = collectionView.frame.width - (edgeInset * 2)
        }
        
        if layoutAttribute.frame.origin.y >= maxY {
          leftMargin = self.sectionInset.left
        }

        layoutAttribute.frame.origin.x = leftMargin
        leftMargin += layoutAttribute.frame.width + self.minimumInteritemSpacing
        maxY = max(layoutAttribute.frame.maxY, maxY)
      }
    }
    
    return copyAttributes
  }
}

// MARK: - Helpers
extension LeftAlignedCollectionViewFlowLayout {
  private func setupReferenceSize() {
    self.headerReferenceSize = CGSize(
      width: UIScreen.main.bounds.size.width,
      height: 60
    )
    self.footerReferenceSize = CGSize(
      width: UIScreen.main.bounds.size.width,
      height: 21
    )
  }
}
