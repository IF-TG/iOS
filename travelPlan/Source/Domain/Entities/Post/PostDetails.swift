//
//  PostDetails.swift
//  travelPlan
//
//  Created by 양승현 on 4/2/24.
//

import Foundation

public struct PostDetails {
  var detail: Post.Detail<[PostContentEntity]>
  let author: Post.Author
  var isFavorite: Bool
  var hasHeart: Bool
  let category: Post.Category
}
