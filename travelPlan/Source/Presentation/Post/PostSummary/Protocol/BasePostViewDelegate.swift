//
//  BasePostViewDelegate.swift
//  travelPlan
//
//  Created by 양승현 on 5/28/24.
//

import Foundation

protocol BasePostViewDelegate: AnyObject {
  func didTapComment()
  func didTapShare()
  func didTapOption()
  func didTapHeart()
}
