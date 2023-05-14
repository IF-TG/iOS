//
//  PostFooterModel.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/14.
//

import Foundation

struct PostFooterModel {
  // heart text
  let heartCount: Int
  // 로그인한 유저가 하트를 눌렀는가?
  let heartState: Bool
  // comment text
  let commentCount: Int
}

// MARK: - Helpers
extension PostFooterModel {
  func isValidatedHeartCount() -> Bool {
    if heartCount >= 0 { return true }
    return false
  }
  func isValidatedCommentCount() -> Bool {
    if commentCount >= 0 { return true }
    return false
  }
}
