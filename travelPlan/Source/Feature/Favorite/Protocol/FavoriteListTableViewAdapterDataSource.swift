//
//  FavoriteListTableViewAdapterDataSource.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/21.
//

import UIKit

protocol FavoriteListTableViewAdapterDataSource: AnyObject {
  var numberOfItems: Int { get }
  var headerItem: FavoriteListHeaderModel { get }
  func cellItem(
    at index: Int
  ) -> FavoriteListTableViewCellModel
}
