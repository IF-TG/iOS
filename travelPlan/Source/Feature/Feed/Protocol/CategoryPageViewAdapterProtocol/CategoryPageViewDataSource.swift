//
//  CategoryPageViewDataSource.swift
//  travelPlan
//
//  Created by 양승현 on 2023/07/02.
//

import Foundation

protocol CategoryPageViewDataSource: AnyObject {
  var numberOfItems: Int { get }
  var travelTrendState: TravelOrderType { get }
  
  func scrollBarLeadingSpacing(_ titleWidth: CGFloat) -> CGFloat  
  func categoryViewCellItem(at index: Int) -> CategoryViewCell.Model
  func travelMainCategoryTitle(at index: Int) -> String
}
