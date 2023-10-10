//
//  FavoriteTableViewCellDelegate.swift
//  travelPlan
//
//  Created by 양승현 on 10/11/23.
//

import UIKit

protocol FavoriteTableViewCellDelegate {
  func favoriteTableViewCell(_ cell: FavoriteTableViewCell, touchUpDirectoryLabel: UILabel)
  func favoriteTableViewCell(_ cell: FavoriteTableViewCell, touchUpDeleteButton: UIButton)
}
