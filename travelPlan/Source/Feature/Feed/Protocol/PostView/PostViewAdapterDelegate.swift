//
//  FeedPostViewAdapterDelegate.swift
//  travelPlan
//
//  Created by 양승현 on 11/8/23.
//

import UIKit

protocol PostViewAdapterDelegate: AnyObject {
  func didTapPost(with postId: Int)
  func didTapHeart(in cell: UICollectionViewCell)
  func didTapComment(in cell: UICollectionViewCell)
  func didTapShare(in cell: UICollectionViewCell)
  func didTapOption(in cell: UICollectionViewCell)
}
