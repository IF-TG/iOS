//
//  FavoritePostViewDelegate.swift
//  travelPlan
//
//  Created by 양승현 on 10/6/23.
//

import UIKit

protocol FavoritePostViewDelegate: AnyObject {
  func scrollDidScroll(
    _ scrollView: UIScrollView,
    scrollYPosition: CGFloat,
    direction: UIScrollView.ScrollVerticalDirection)
}
