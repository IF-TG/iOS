//
//  PostDetails.swift
//  travelPlan
//
//  Created by 양승현 on 4/2/24.
//

import Foundation

struct PostDetails {
  let detail: Post.Detail<[PostDetailContentType]>
  let author: Post.Author
  let isFavorite: Bool
  let category: PostCategory
  var comments: [PostComment] = []
}
