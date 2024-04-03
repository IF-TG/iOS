//
//  UITableView+Helpers.swift
//  travelPlan
//
//  Created by 양승현 on 4/3/24.
//

import UIKit

// MARK: - TableView Section Helpers
extension UITableView {
  func section(for header: UITableViewHeaderFooterView) -> Int? {
    let relativePoint = convert(header.frame.origin, to: self)
    for specificSection in 0..<self.numberOfSections
    where rectForHeader(inSection: specificSection).contains(relativePoint) {
      return specificSection
    }
    return nil
  }
}
