//
//  FavoritePostViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 3/20/24.
//

import Foundation
import Combine

// TODO: - PostViewModel을 임시로 준수했습니다. 찜한 포스트를 불러오는 api를 구현 후 적용해야합니다.
final class FavoritePostViewModel: PostViewModel {
  // MARK: - Dependencies
  let postUseCase: PostUseCase
  
  // MARK: - Properties
  var posts: [PostInfo] = []
  
  var thumbnails: [[String]] = []
  
  var perPage: Int32 = 10
  
  var currentPage: Int32 = 0
  
  var nextPage: Int32 { hasMorePages ? currentPage + 1 : currentPage }
  
  var totalPostsCount: Int32 = 0
  
  var hasMorePages: Bool {
    let totalPageCount = totalPostsCount/perPage
    return currentPage < totalPageCount
  }
  
  var isPaging: Bool = false
  
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
