//
//  PostFooterInfo.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/14.
//

import Foundation

struct PostFooterInfo {
  // heart text
  let heartCount: Int
  // 로그인한 유저가 하트를 눌렀는가?
  let heartState: Bool
  // comment text
  let commentCount: Int
  
  // 데이터가 유효하지 않은 경우
  init(
    heartCount: Int = 0,
    heartState: Bool = false,
    commentCount: Int = 0) {
    self.heartCount = heartCount
    self.heartState = heartState
    self.commentCount = commentCount
  }
}

// MARK: - Helpers
extension PostFooterInfo {
  func isValidatedHeartCount() -> Bool {
    if heartCount >= 0 { return true }
    return false
  }
  func isValidatedCommentCount() -> Bool {
    if commentCount >= 0 { return true }
    return false
  }
}
