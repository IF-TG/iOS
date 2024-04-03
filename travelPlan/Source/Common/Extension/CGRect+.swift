//
//  CGRect+.swift
//  travelPlan
//
//  Created by 양승현 on 4/3/24.
//

import Foundation

extension CGRect {
  /// ALternate Legacy CGGeometry Functions: CGRectContainsPoint
  func isContained(point: CGPoint) -> Bool {
    return (minX <= point.x &&
            point.x <= maxX &&
            minY <= point.y &&
            point.y <= maxY)
  }
}
