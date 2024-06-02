//
//  PostViewAdapterDelegate.swift
//  travelPlan
//
//  Created by 양승현 on 11/8/23.
//

import UIKit

protocol PostViewAdapterDelegate: AnyObject {
  func didTapPost(with postIndex: Int)
  func scrollToNextPage()
  
  func tapComment(_ cell: UICollectionViewCell)
  func share(_ cell: UICollectionViewCell)
  func tapOption(_ cell: UICollectionViewCell)
  func tapHeart(_ cell: UICollectionViewCell)
}
