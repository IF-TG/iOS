//
//  CategoryPageViewDelegate.swift
//  travelPlan
//
//  Created by 양승현 on 2023/07/02.
//

import Foundation

protocol CategoryPageViewDelegate: AnyObject {
  func didSelectItemAt(_ indexPath: IndexPath, spacing: CGFloat)
}
