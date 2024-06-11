//
//  CellIdentifiable.swift
//  travelPlan
//
//  Created by 양승현 on 6/1/24.
//

import UIKit

protocol CellIdentifiable {}

extension CellIdentifiable where Self: UICollectionViewCell {
  static var identifier: String {
    return String(describing: self)
  }
}

extension CellIdentifiable where Self: UITableViewCell {
  static var identifier: String {
    return String(describing: self)
  }
}

extension UICollectionViewCell: CellIdentifiable {}
extension UITableViewCell: CellIdentifiable {}
