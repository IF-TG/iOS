//
//  MoreCategoryViewDelegate.swift
//  travelPlan
//
//  Created by 양승현 on 2023/07/04.
//

protocol MoreCategoryViewDelegate: AnyObject {
  func moreCategoryView(_ moreCategoryView: MoreCategoryView, didSelectedType type: TravelCategoryDetailType)
}
