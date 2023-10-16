//
//  PostViewAdapterDataSource.swift
//  travelPlan
//
//  Created by 양승현 on 10/16/23.
//

protocol PostViewAdapterDataSource: AnyObject {
  var numberOfItems: Int { get }
  var travelTheme: TravelMainThemeType { get }
  var travelTrend: TravelOrderType { get }
  
  func postViewCellItem(at index: Int) -> PostInfo
  func contentText(at index: Int) -> String
}
