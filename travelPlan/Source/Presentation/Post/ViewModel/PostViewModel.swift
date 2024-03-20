//
//  PostViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 2023/05/14.
//

import Combine
import Foundation

protocol PostDataSource {
  var posts: [PostInfo] { get }
  var thumbnails: [[String]] { get }
  var currentPage: Int32 { get }
  var nextPage: Int32 { get }
  var totalPostsCount: Int32 { get }
  var hasMorePages: Bool { get }
  var perPage: Int32 { get }
  var isPaging: Bool { get }
  
  func fetchPosts() -> AnyPublisher<[Post], Error>
}

typealias PostViewModel = PostDataSource & PostViewAdapterDataSource
