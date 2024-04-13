//
//  ReviewWritingEntity.swift
//  travelPlan
//
//  Created by SeokHyun on 4/10/24.
//

import Foundation

struct ReviewWritingEntity {
  let category: Post.Category
  let tripData: Post.TripDate
  let title: String
  let contents: [PostContentEntity]
}
