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
  private let postFetchUsecase: PostFetchUseCase
  
  // MARK: - Properties
  var posts: [Post] = []
  
  var postThumbnails: [[Data]] = []
  
  var perPage: Int32 = 10
  
  var currentPage: Int32 = 1
  
  var nextPage: Int32 { hasMorePages ? currentPage + 1 : currentPage }
  
  var totalPostsCount: Int32 = 100
  
  var hasMorePages: Bool {
    let totalPageCount = totalPostsCount/perPage
    return currentPage < totalPageCount
  }
  
  var isPaging: Bool = false
  
  // MARK: - Lifecycle
  init(postFetchUsecase: PostFetchUseCase) {
    self.postFetchUsecase = postFetchUsecase
  }
}

// MARK: - PostDataSource
extension FavoritePostViewModel {
  func fetchPosts() -> AnyPublisher<Void, any Error> {
    Empty().eraseToAnyPublisher()
  }
}

// MARK: - PostViewAdapterDataSource
extension FavoritePostViewModel {
  var numberOfItems: Int {
    posts.count
  }
  
  func numberOfThumbnailsInPost(at index: Int) -> PostThumbnailCountValue {
    .init(postThumbnails[index].count)
  }
  
  func postItem(at index: Int) -> PostInfo {
    let post = posts[index]
    let postInfo = PostMapper.toPostInfo(post, thumbnails: postThumbnails[index])
    return postInfo
  }
}
