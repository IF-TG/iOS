//
//  FavoritePostViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 3/20/24.
//

import Foundation
import Combine

final class FavoritePostViewModel: PostViewModel {
  // MARK: - Dependencies
  let postUseCase: PostUseCase
  
  // MARK: - Properties
  var posts: [PostInfo] = []
  
  var thumbnails: [[String]] = []
  
  var page: Int32 = 0
  
  var perPage: Int32 = 10
  
  // MARK: - Lifecycle
  init(postUseCase: PostUseCase) {
    self.postUseCase = postUseCase
  }
}

// MARK: - PostDataSource
extension FavoritePostViewModel {
  func fetchPosts() -> AnyPublisher<[Post], any Error> {
    Empty().eraseToAnyPublisher()
  }
}

// MARK: - PostViewAdapterDataSource
extension FavoritePostViewModel {
  var numberOfItems: Int {
    posts.count
  }
  
  func numberOfThumbnailsInPost(at index: Int) -> PostThumbnailCountValue {
    .init(thumbnails[index].count)
  }
  
  func postItem(at index: Int) -> PostInfo {
    return posts[index]
  }
}
