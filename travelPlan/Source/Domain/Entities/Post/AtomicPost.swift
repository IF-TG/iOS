//
//  AtomicPost.swift
//  travelPlan
//
//  Created by 양승현 on 5/15/24.
//

import Foundation

struct AtomicPost {
  let authorId: String
  let detail: Post.Detail<[Post.PostContent]>
  let category: Post.Category
  let highResolveImages: [Post.PostImage]
}
