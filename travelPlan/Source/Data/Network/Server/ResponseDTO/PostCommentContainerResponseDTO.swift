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

// MARK: - Mappings to Domain
extension PostCommentContainerResponseDTO {
  func toDomain(
    with userProfileImageDataList: [Data?],
    nestedCommentAuthorProfileImageDataList: [[Data?]]) -> PostCommentContainerEntity {
    return .init(
      comments: comments.enumerated().map { $1.toDomain(
        with: userProfileImageDataList[$0],
        nestedCommentAuthorsImageData: nestedCommentAuthorProfileImageDataList[$0]) },
      isFavorited: isFavorited)
  }
}
