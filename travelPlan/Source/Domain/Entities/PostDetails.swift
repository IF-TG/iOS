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
  var isFavorite: Bool
  let category: Post.Category
  var comments: [PostCommentEntity] = []
}
