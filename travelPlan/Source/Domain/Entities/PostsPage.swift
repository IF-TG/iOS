//
//  PostsPage.swift
//  travelPlan
//
//  Created by 양승현 on 3/7/24.
//

import Foundation

struct PostsPage {
  // FIXME: - 임시로 추가. 추후 서버 api 에 totalPages나 totalPosts 추가되면 그에 맞춰 바꿔야합니다.
  let totalPosts: Int64
  let posts: [Post]
  let thumbnails: [PostThumbnails]
}
