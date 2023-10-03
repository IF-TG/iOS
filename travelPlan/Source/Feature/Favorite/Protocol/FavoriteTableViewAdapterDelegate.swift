//
//  FavoriteTableViewAdapterDelegate.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/21.
//

import Foundation

protocol FavoriteTableViewAdapterDelegate: AnyObject {
  func tappedCell(with data: FavoriteTableViewCell.Model) 
}
