//
//  PostDetailChatDataSource.swift
//  travelPlan
//
//  Created by 양승현 on 5/21/24.
//

import Foundation

protocol PostDetailChatDataSource: AnyObject {
  func commentItem(in section: Int) -> PostCommentInfo
  func replyItem(at indexPath: IndexPath) -> PostReplyInfo
}
