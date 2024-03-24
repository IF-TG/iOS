//
//  PostContainer.swift
//  travelPlan
//
//  Created by 양승현 on 3/8/24.
//

import Foundation

struct PostContainer {
  let post: Post
  let thumbnails: [String]
  // FIXME: - 임시로 추가. 추후 서버 api 변경되면 그에맞춰 바꿔야합니다.
  let totalPosts: Int64
}
