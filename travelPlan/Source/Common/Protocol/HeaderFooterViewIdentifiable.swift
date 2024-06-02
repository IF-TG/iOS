//
//  HeaderFooterViewIdentifiable.swift
//  travelPlan
//
//  Created by 양승현 on 6/2/24.
//

import UIKit.UITableViewHeaderFooterView

protocol HeaderFooterViewIdentifiable {}

extension HeaderFooterViewIdentifiable where Self: UITableViewHeaderFooterView {
  static var identifier: String {
    return String(describing: self)
  }
}
