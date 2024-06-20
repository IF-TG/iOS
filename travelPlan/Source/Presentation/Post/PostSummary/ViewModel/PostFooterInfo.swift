//
//  PostFooterInfo.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/14.
//

import Foundation

struct PostFooterInfo {
  // heart text
  let heartCount: String
  // 로그인한 유저가 하트를 눌렀는가?
  let heartState: Bool
  // comment text
  let commentCount: String
  
  static func makeDefault() -> Self {
    return Self(heartCount: "0", heartState: false, commentCount: "0")
  }
}
