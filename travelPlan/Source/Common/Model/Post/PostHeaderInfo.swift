//
//  PostHeaderInfo.swift
//  travelPlan
//
//  Created by 양승현 on 10/17/23.
//

import Foundation

struct PostHeaderInfo {
  let title: String
  let image: String?
  let subInfo: PostHeaderContentBottomInfo
  
  init(
    title: String = "제목 없음",
    image: String? = nil,
    subInfo: PostHeaderContentBottomInfo = PostHeaderContentBottomInfo()
  ) {
    self.title = title
    self.image = image
    self.subInfo = subInfo
  }
}
