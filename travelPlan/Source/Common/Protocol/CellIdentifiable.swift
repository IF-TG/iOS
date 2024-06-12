//
//  CellIdentifiable.swift
//  travelPlan
//
//  Created by 양승현 on 6/1/24.
//

import UIKit

protocol CellIdentifiable {}

extension CellIdentifiable {
  static var identifier: String {
    return String(describing: self)
  }
}

extension UITableViewCell: CellIdentifiable {}
extension UICollectionReusableView: CellIdentifiable {}
