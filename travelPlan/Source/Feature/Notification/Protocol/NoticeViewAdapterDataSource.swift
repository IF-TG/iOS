//
//  NoticeViewAdapterDataSource.swift
//  travelPlan
//
//  Created by 양승현 on 10/29/23.
//

import Foundation

protocol NoticeViewAdapterDataSource: AnyObject {
  var numberOfItems: Int { get }
  
  func getItem(_ indexPath: IndexPath) -> NoticeCellInfo
}
