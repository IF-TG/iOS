//
//  FavoritePostViewAdapterDelegate.swift
//  travelPlan
//
//  Created by 양승현 on 10/6/23.
//

import UIKit

protocol FavoritePostViewAdapterDelegate: AnyObject {
  func scrollDidScroll(
    _ scrollView: UIScrollView,
    scrollYPosition: CGFloat,
    direction: UIScrollView.ScrollVerticalDirection)
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView, scrollYPosition: CGFloat)
}
