//
//  DefaultPostUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 3/8/24.
//

import Foundation
import Combine

final class DefaultPostUseCase: PostUseCase {
  // MARK: - Dependencies
  private let postRepository: PostRepository
  
  private let backgroundQueue: DispatchQueue

  // MARK: - Lifecycle
  init(postRepository: PostRepository, backgroundQueue: DispatchQueue = .global(qos: .default)) {
    self.postRepository = postRepository
    self.backgroundQueue = backgroundQueue
  }
  
  func fetchPosts(with page: PostFetchRequestValue) -> AnyPublisher<PostsPage, any Error> {
    // TODO: - liked가 nil인 경우 호출해서 받아와야 합니다.
    return postRepository.fetchPosts(
      page: page.page,
      perPage: page.perPage,
      category: page.category)
    .subscribe(on: backgroundQueue)
    .eraseToAnyPublisher()
  }
  
  func fetchComments(
    with requestValue: PostCommentsRequestValue
  ) -> AnyPublisher<PostCommentContainerEntity, any Error> {
    postRepository.fetchComments(
      page: requestValue.page,
      perPage: requestValue.perPage,
      postId: requestValue.postId)
    .subscribe(on: backgroundQueue)
    .eraseToAnyPublisher()
  }
  
  func fetchLikedPostsByLoggedInUser(
    page: Int32,
    perPage: Int32
  ) -> AnyPublisher<PostsPage, any Error> {
    postRepository.fetchLikedPostsByLoggedInUser(
      page: page,
      perPage: perPage)
    .subscribe(on: backgroundQueue)
    .eraseToAnyPublisher()
  }
  
  func searchPosts(
    keyword: String,
    page: Int32,
    perPage: Int32,
    isTitle: Bool,
    isContent: Bool
  ) -> AnyPublisher<[Post], any Error> {
    postRepository.searchPosts(
      keyword: keyword,
      page: page,
      perPage: perPage,
      isTitle: isTitle,
      isContent: isContent)
    .subscribe(on: backgroundQueue)
    .eraseToAnyPublisher()
  }
}
