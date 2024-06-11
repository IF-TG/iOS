//
//  FeedPostViewAdapterDataSource.swift
//  travelPlan
//
//  Created by 양승현 on 10/22/23.
//

import Foundation

protocol FeedPostViewAdapterDataSource: PostViewAdapterDataSource {
  var headerItem: PostFilterOptions { get }
  
  func postInfoForPostOption(from indexPath: IndexPath) -> (postId: Int32, authorId: Int32, authorName: String)
}
