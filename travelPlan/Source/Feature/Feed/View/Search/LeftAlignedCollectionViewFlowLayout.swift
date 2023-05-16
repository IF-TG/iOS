//
//  LeftAlignedCollectionViewFlowLayout.swift
//  travelPlan
//
//  Created by SeokHyun on 2023/05/10.
//

import UIKit

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
  // MARK: - LifeCycle
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    // layout 속성값
    guard let attributes = super.layoutAttributesForElements(in: rect) else { return [] }
    
    // contentView의 left 여백
    var leftMargin = self.sectionInset.left
    // cell 라인 y의 start
    var maxY: CGFloat = -1.0
    let edgeInset: CGFloat = 20
    
    attributes.forEach { layoutAttribute in
      if layoutAttribute.representedElementCategory == .cell {
        
        guard let collectionView = collectionView else { return }
        // Label의 text가 화면을 넘어가는 경우, cell size 고정
        if layoutAttribute.frame.width >= collectionView.frame.width - (edgeInset * 2) {
          layoutAttribute.frame.size.width = collectionView.frame.width - (edgeInset * 2)
        }
        
        // 한 cell의 y값이 이전 cell들이 들어갔던 line의 y값보다 크다면
        if layoutAttribute.frame.origin.y >= maxY {
          // x좌표 left에서 시작 (default값을 -1 주었기 때문에 처음은 무조건 실행)
          leftMargin = self.sectionInset.left
        }
        // cell의 x좌표에 leftMargin값 적용해주고
        layoutAttribute.frame.origin.x = leftMargin
        // cell의 다음 값 만큼 cellWidth + minimumInterItemSpacing
        leftMargin += layoutAttribute.frame.width + self.minimumInteritemSpacing
        // cell의 위치 값과 maxY 변수 값 중 최대값 넣어줌 (라인 y축 값 업데이트)
        maxY = max(layoutAttribute.frame.maxY, maxY)
      }
    }
    
    return attributes
  }
}
