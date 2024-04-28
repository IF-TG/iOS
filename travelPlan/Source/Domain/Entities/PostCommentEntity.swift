//
//  PostCommentEntity.swift
//  travelPlan
//
//  Created by 양승현 on 11/10/23.
//

import Foundation

struct PostCommentEntity {
  // TODO: - 여기에 comment남긴 userId도 있어야 내가올렸는지 타인이 올렸는지 -> 식별 가능합니다.
  // -> 댓글 수정, 삭제 기능 .. 
  let commentId: Int64
  var userProfileImageData: Data?
  var userName: String
  var timestamp: String
  var comment: String
  var isDeleted: Bool
  var isOnHeart: Bool
  var isBlocked: Bool
  var hearts: Int32
  var nestedComments: [PostNestedCommentEntity]
}
