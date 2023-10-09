//
//  FavoriteTableViewAdapterDelegate.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/21.
//

import UIKit

protocol FavoriteTableViewAdapterDelegate: AnyObject {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
}
