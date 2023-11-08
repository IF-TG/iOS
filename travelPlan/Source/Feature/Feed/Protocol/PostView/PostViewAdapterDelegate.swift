//
//  FeedPostViewAdapterDelegate.swift
//  travelPlan
//
//  Created by 양승현 on 11/8/23.
//

import Foundation

protocol PostViewAdapterDelegate: AnyObject {
  func didTapPost(with postId: Int)
}
