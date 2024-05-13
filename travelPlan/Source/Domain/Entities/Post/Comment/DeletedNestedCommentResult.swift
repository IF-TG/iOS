//
//  DeletedNestedCommentResult.swift
//  travelPlan
//
//  Created by 양승현 on 5/14/24.
//

import Foundation

@frozen enum DeletedNestedCommentResult {
  /// 댓글이 삭제되지 않은 상태에서 대댓글 제거 완료
  case deletedJustNestedComment
  /// 대댓글도 제거, 해당 대댓글을 소유한 댓글도 제거 완료
  case deletedACommentAndAllNestedComments
  }
