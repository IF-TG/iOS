//
//  ReviewWritingEntity.swift
//  travelPlan
//
//  Created by SeokHyun on 4/10/24.
//

import Foundation

struct ReviewWritingEntity {
  let postId: PostIdentifier
  var category: Post.Category
  var tripDate: Post.TripDate
  var title: String
  var contents: [PostContentEntity]
  var mapX: Double = 0.0
  var mapY: Double = 0.0
  
  // firestore일때 authorId가 필요합니다.
  var authorId: UserIdentifier?
}
