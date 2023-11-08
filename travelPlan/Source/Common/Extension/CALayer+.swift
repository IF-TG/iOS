//
//  CALayer.swift
//  travelPlan
//
//  Created by 양승현 on 11/2/23.
//

import UIKit

extension CALayer {
  @frozen enum CornerPosition {
    /// 왼쪽 아래
    case leftBottom
    
    /// 왼쪽 위
    case leftTop
    
    /// 오른쪽 위
    case rightTop
    
    /// 오른쪽 아래
    case rightBottom
    
    var cornerMask: CACornerMask {
      let dict = [
        .leftBottom: .layerMinXMaxYCorner,
        .rightBottom: .layerMaxXMaxYCorner,
        .leftTop: .layerMinXMinYCorner,
        .rightTop: .layerMaxXMinYCorner
      ] as [Self: CACornerMask]
      return dict[self]!
    }
  }
  
  /// layer의 꼭지점에 radius 줄 수 있는 함수입니다.
  func setCornerMask(_ position: CornerPosition...) {
    maskedCorners = position.map { $0.cornerMask }.reduce([]) { $0.union($1) }
  }
}
