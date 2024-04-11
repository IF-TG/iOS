//
//  PostDetailTableViewDataSource.swift
//  travelPlan
//
//  Created by 양승현 on 11/7/23.
//

import Foundation

protocol PostDetailTableViewDataSource: AnyObject {
  var numberOfSections: Int { get }
  
  var title: String { get }
  var cateogry: String { get }
  var profileAreaItem: PostDetailProfileAreaInfo { get }
  
  var authorUserId: Int32 { get }
  
  func numberOfRows(in section: Int) -> Int
  func postContentItem(at row: Int) -> PostContentEntity
  
  func commentItem(in section: Int) -> PostCommentInfo
  func replyItem(at indexPath: IndexPath) -> PostReplyInfo
}
