//
//  FavoriteTableViewCellDelegate.swift
//  travelPlan
//
//  Created by 양승현 on 10/11/23.
//

import UIKit

protocol FavoriteTableViewCellDelegate: AnyObject {
  func favoriteTableViewCell(_ cell: FavoriteTableViewCell, touchUpEditModeTitleLabel label: UILabel)
  func favoriteTableViewCell(_ cell: FavoriteTableViewCell, touchUpDeleteButton button: UIButton)
}
