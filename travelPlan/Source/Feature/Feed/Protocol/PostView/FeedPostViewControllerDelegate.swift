//
//  FeedPostViewControllerDelegate.swift
//  travelPlan
//
//  Created by 양승현 on 12/20/23.
//

import Foundation

protocol FeedPostViewControllerDelegate: AnyObject {
  func didTapPost(with postId: Int)
  func didTapComment(with postId: Int)
  func didTapShare(with postId: Int)
  func didTapOption(with postId: Int)
}
