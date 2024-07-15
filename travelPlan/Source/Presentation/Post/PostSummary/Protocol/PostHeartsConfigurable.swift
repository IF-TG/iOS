//
//  PostHeartsConfigurable.swift
//  travelPlan
//
//  Created by 양승현 on 7/13/24.
//

import Foundation

protocol PostHeartsConfigurable {
  func setPostHearts(with hearts: Int32)
  func setPostHeartUI(with hasHeart: Bool)
}

extension PostHeartsConfigurable where Self: PostCellLayouter {
  func setPostHearts(with hearts: Int32) {
    self.postView.setPostHearts(with: hearts)
  }
  
  func setPostHeartUI(with hasHeart: Bool) {
    self.postView.setPostHeartUI(with: hasHeart)
  }
}
