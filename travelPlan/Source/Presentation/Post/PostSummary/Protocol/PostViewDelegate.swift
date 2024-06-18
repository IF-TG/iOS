//
//  PostViewDelegate.swift
//  travelPlan
//
//  Created by 양승현 on 5/28/24.
//

import UIKit

protocol PostViewDelegate: AnyObject {
  func didTapShare(_ cell: UICollectionViewCell)
  func didTapOption(_ cell: UICollectionViewCell)
  func didTapHeart(_ cell: UICollectionViewCell)
}
