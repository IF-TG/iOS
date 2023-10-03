//
//  FavoriteTableViewAdapterDataSource.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/21.
//

import UIKit

protocol FavoriteTableViewAdapterDataSource: AnyObject {
  var numberOfItems: Int { get }
  var headerItem: FavoriteHeaderModel { get }
  func cellItem(
    at index: Int
  ) -> FavoriteTableViewCellModel
}
