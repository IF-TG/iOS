//
//  FeedPostViewAdapterDataSource.swift
//  travelPlan
//
//  Created by 양승현 on 10/22/23.
//

import Foundation

struct PostOptionInfo {
  let postId: Int32
  let authorId: Int32
  let authorName: String
  let postTitle: String
}

protocol FeedPostViewAdapterDataSource: PostViewAdapterDataSource {
  var headerItem: PostFilterOptions { get }
  
  func postInfoForPostOption(from indexPath: IndexPath) -> PostOptionInfo
}
