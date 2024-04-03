//
//  UITableView+Helpers.swift
//  travelPlan
//
//  Created by 양승현 on 4/3/24.
//

import UIKit

// MARK: - TableView Section Helpers
extension UITableView {
  /// 런타임때 동적으로 section의 item추가시 정확히 section을 받아오지 못할 수 있다.... 섹션의 frame이 바뀜으로,,
  func section(for header: UITableViewHeaderFooterView) -> Int? {
    let relativePoint = convert(header.frame.origin, to: self)
    for specificSection in 0..<self.numberOfSections
    where rectForHeader(inSection: specificSection).contains(relativePoint) {
      return specificSection
    }
    return nil
  }
}
