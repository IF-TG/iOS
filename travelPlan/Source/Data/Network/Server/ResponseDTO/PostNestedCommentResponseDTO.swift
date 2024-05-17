//
//  PostNestedCommentResponseDTO.swift
//  travelPlan
//
//  Created by 양승현 on 3/23/24.
//

import Foundation

struct PostNestedCommentResponseDTO: Decodable {
  let nestedCommentId: String
  let userProfileURL: String
  let nickname: String
  let timestamp: String
  let comment: String
  let hearts: Int32
  let isOnHeart: Bool
  // MARK: 서버에서는 대댓글의 authorId를 추가해야합니다. 그래야 내가올렸는지 타인이 올렸는지에 따라 편집하기 등의 로직수행이 가능합니다.
  
  enum CodingKeys: String, CodingKey {
    case nestedCommentId
    case userProfileURL = "profileImgUri"
    case nickname
    case timestamp = "crateAt"
    case comment
    case hearts = "likeNum"
    case isOnHeart = "liked"
  }
  
  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.nestedCommentId = try container.decode(String.self, forKey: .nestedCommentId)
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
  func toDomain(with userProfileImageData: Data?) -> PostNestedCommentEntity {
    return PostNestedCommentEntity(
      nestedCommentId: nestedCommentId,
      authorId: "",
      userProfileImageData: userProfileImageData,
      nickname: nickname,
      timestamp: timestamp,
      comment: comment,
      hearts: hearts,
      isOnHeart: isOnHeart)
  }
}
