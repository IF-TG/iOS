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
  
  var postFooterItem: PostFooterInfo { get }
  
  var authorUserId: UserIdentifier? { get }
  
  func postContentItem(at row: Int) -> PostContentEntity
  func numberOfRows(in section: Int) -> Int
}
