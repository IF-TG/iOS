//
//  MoreMenuViewDelegate.swift
//  travelPlan
//
//  Created by 양승현 on 2023/07/04.
//

protocol MoreMenuViewDelegate: AnyObject {
  func moreMenuView(
    _ moreMenuView: MoreMenuView,
    didSelectedType type: TravelCategorySortingType)
}
