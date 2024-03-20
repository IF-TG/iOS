//
//  FeedPostViewModel.swift
//  travelPlan
//
//  Created by 양승현 on 10/23/23.
//

import Foundation
import Combine

class FeedPostViewModel: PostViewModel {
  // MARK: - Properties
  var page: Int32 = 0
  
  let perPage: Int32 = 10
  
  var posts: [PostInfo] = []
  
  var thumbnails: [[String]] = []
  
  private let category: PostCategory
  
  private let postUseCase: PostUseCase
  
  // MARK: - Lifecycle
  init(filterInfo: PostCategory, postUseCase: PostUseCase) {
    self.postUseCase = postUseCase
    self.category = filterInfo
  }
}

// MARK: - FeedPostViewModelable
extension FeedPostViewModel: FeedPostViewModelable {
  func transform(_ input: Input) -> AnyPublisher<State, Never> {
    return Publishers.MergeMany([
      viewDidLoadStream(input),
      postsStream()]
    ).eraseToAnyPublisher()
  }
}

private extension FeedPostViewModel {
  func viewDidLoadStream(_ input: Input) -> Output {
    return input.viewDidLoad
      .map {_ in return .none }
      .eraseToAnyPublisher()
  }
  func postsStream() -> Output {
    return Just(State.none).eraseToAnyPublisher()
  }
}

// MARK: - PostDataSource
extension FeedPostViewModel {
  func fetchPosts() -> AnyPublisher<[Post], any Error> {
    let category = PostCategory(
      mainTheme: category.mainTheme,
      orderBy: category.orderBy)
    let postFetchRequestValue = PostFetchRequestValue(
      page: page,
      perPage: perPage,
      category: category)
    return postUseCase.fetchPosts(with: postFetchRequestValue)
      .map { postContainers in
        postContainers.map { [weak self] postContainer in
          self?.thumbnails.append(postContainer.thumbnails)
          return postContainer.post
        }
      }.eraseToAnyPublisher()
  }
}

// MARK: - FeedPostViewAdapterDataSource
extension FeedPostViewModel: FeedPostViewAdapterDataSource {
  var headerItem: PostFilterOptions {
    return .travelMainTheme(category.mainTheme)
  }
  
  var numberOfItems: Int {
    posts.count
  }
  
  func numberOfThumbnailsInPost(at index: Int) -> PostThumbnailCountValue {
    return PostThumbnailCountValue(postItem(at: index).content.thumbnailURLs.count)
  }
  
  func postItem(at index: Int) -> PostInfo {
    return posts[index]
  }
}
