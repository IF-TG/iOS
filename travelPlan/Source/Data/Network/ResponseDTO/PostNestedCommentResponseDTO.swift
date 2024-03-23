//
//  PostNestedCommentResponseDTO.swift
//  travelPlan
//
//  Created by 양승현 on 3/23/24.
//

import Foundation

struct PostNestedCommentResponseDTO: Decodable {
  let replyId: Int64
  let userProfileURL: String
  let nickname: String
  let timestamp: String
  let comment: String
  let likes: Int32
  let isLiked: Bool
  
  enum CodingKeys: String, CodingKey {
    case replyId = "nestedCommentId"
    case userProfileURL = "profileImgUri"
    case nickname
    // FIXME: - 경완이한테 알려주고 추후 경완이가 api 개선하면 그에 따라 바꾸기
    case timestamp = "crateAt"
    case comment
    case likes = "likeNum"
    case isLiked = "liked"
  }
}
