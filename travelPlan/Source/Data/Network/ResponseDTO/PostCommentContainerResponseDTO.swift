//
//  PostCommentContainerResponseDTO.swift
//  travelPlan
//
//  Created by 양승현 on 3/23/24.
//

import Foundation

struct PostCommentContainerResponseDTO: Decodable {
  let comments: [PostCommentResponseDTO]
  let isFavorited: Bool
  
  enum CodingKeys: String, CodingKey {
    case comments = "commentList"
    case isFavorited = "scraped"
  }
}
