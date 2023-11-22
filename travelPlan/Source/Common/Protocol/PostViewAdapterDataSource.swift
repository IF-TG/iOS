//
//  PostViewAdapterDataSource.swift
//  travelPlan
//
//  Created by 양승현 on 10/16/23.
//

protocol PostViewAdapterDataSource: AnyObject {
  var numberOfItems: Int { get }
  func numberOfThumbnailsInPost(at index: Int) -> Int
  func postItem(at index: Int) -> PostInfo
}
