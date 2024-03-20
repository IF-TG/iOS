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
  var page: Int32 { get }
  var perPage: Int32 { get }
  
  func fetchPosts() -> AnyPublisher<Post, Error>
}

typealias PostViewModel = PostDataSource & PostViewAdapterDataSource
