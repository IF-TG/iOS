//
//  CategoryPageViewDataSource.swift
//  travelPlan
//
//  Created by 양승현 on 2023/07/02.
//

import Foundation

protocol CategoryPageViewDataSource: AnyObject {
  var numberOfItems: Int { get }
  
  func cellItem(at index: Int) -> TravelMainCategoryViewCell.Model
  func travelMainCategoryTitle(at index: Int) -> String
  func postSearchFilterItem(at index: Int) -> FeedPostSearchFilterInfo
}
