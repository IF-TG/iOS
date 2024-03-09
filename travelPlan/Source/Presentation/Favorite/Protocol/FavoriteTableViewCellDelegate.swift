//
//  FavoriteTableViewCellDelegate.swift
//  travelPlan
//
//  Created by 양승현 on 10/11/23.
//

import UIKit

protocol FavoriteTableViewCellDelegate: AnyObject {
  func favoriteTableViewCell(_ cell: UITableViewCell, touchUpEditModeTitleLabel label: UILabel)
  func favoriteTableViewCell(_ cell: UITableViewCell, touchUpDeleteButton button: UIButton)
}
