//
//  PostNestedCommentResponseDTO.swift
//  travelPlan
//
//  Created by 양승현 on 3/23/24.
//

import Foundation

struct PostNestedCommentResponseDTO: Decodable {
  let nestedCommentId: Int64
  let userProfileURL: String
  let nickname: String
  let timestamp: String
  let comment: String
  let hearts: Int32
  let isOnHeart: Bool
  
  enum CodingKeys: String, CodingKey {
    case nestedCommentId
    case userProfileURL = "profileImgUri"
    case nickname
    // FIXME: - 경완이한테 알려주고 추후 경완이가 api 개선하면 그에 따라 바꾸기
    case timestamp = "crateAt"
    case comment
    case hearts = "likeNum"
    case isOnHeart = "liked"
  }
  
  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.nestedCommentId = try container.decode(Int64.self, forKey: .nestedCommentId)
    self.userProfileURL = try container.decode(String.self, forKey: .userProfileURL)
    self.nickname = try container.decode(String.self, forKey: .nickname)
    self.timestamp = try container.decode(String.self, forKey: .timestamp)
    self.comment = try container.decode(String.self, forKey: .comment)
    self.hearts = try container.decode(Int32.self, forKey: .hearts)
    self.isOnHeart = try container.decode(Bool.self, forKey: .isOnHeart)
  }
}

// MARK: - Mappings to Domain
extension PostNestedCommentResponseDTO {
  func toDomain() -> PostNestedCommentEntity {
    return PostNestedCommentEntity(
      nestedCommentId: nestedCommentId,
      userProfileURL: userProfileURL,
      nickname: nickname,
      timestamp: timestamp,
      comment: comment,
      hearts: hearts,
      isOnHeart: isOnHeart)
  }
}
