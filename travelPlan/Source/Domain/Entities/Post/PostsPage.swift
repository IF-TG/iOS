//
//  PostsPage.swift
//  travelPlan
//
//  Created by 양승현 on 3/7/24.
//

import Foundation

struct PostsPage {
  let totalPosts: Int64
  let posts: [Post]
  var thumbnails: [PostThumbnails]
  var hasMorePage: Bool = true
}
