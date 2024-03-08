//
//  FavoriteTableViewAdapterDelegate.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/21.
//

import UIKit

protocol FavoriteTableViewAdapterDelegate: AnyObject {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
  func tableViewCell(_ cell: UITableViewCell, didTapEditModeTitle title: String?)
  func tableViewCell(_ cell: UITableViewCell, didtapDeleteButton: UIButton)
}
