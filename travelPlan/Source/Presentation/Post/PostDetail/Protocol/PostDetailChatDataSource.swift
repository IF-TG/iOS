//
//  PostDetailChatDataSource.swift
//  travelPlan
//
//  Created by 양승현 on 5/21/24.
//

import Foundation

protocol PostDetailChatDataSource: AnyObject {
  typealias NumberOfComments = Int
  
  func commentItem(in section: PostDetailSection) -> PostCommentInfo
  func replyItem(at indexPath: IndexPath) -> PostReplyInfo
  
  var numberOfSections: NumberOfComments { get }
  func numberOfRows(in section: PostDetailSection) -> Int
}
