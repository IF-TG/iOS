//
//  PostDetailTableViewDataSource.swift
//  travelPlan
//
//  Created by 양승현 on 11/7/23.
//

import Foundation

protocol PostDetailTableViewDataSource: AnyObject {
  var numberOfSections: Int { get }
  
  func numberOfItems(in section: Int) -> Int
  func postContentItem(at index: Int) -> PostDetailContentInfo
}
