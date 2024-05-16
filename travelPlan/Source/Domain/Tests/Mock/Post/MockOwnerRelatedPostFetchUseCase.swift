//
//  MockOwnerRelatedPostFetchUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 5/16/24.
//

import Combine
import Foundation

final class MockOwnerRelatedPostFetchUseCase: OwnerRelatedPostFetchUseCase {
  var mockPostsGenerator1 = MockPostsGeneratorForPaging()
  var mockPostsGenerator2 = MockPostsGeneratorForPaging()
  
  func fetchOwnerLikedPosts(page: Int32, perPage: Int32) -> AnyPublisher<PostsPage, any Error> {
    if mockPostsGenerator1.index > mockPostsGenerator1.totalPage {
      return Fail(error: PostUseCaseError.noMorePage).eraseToAnyPublisher()
    }
    let responseData = {
      let nextPosts = (mockPostsGenerator1.index..<mockPostsGenerator1.index+5)
        .map { mockPostsGenerator1.mockPostPage.posts[$0] }
      let nextThumbnails = (mockPostsGenerator1.index..<mockPostsGenerator1.index+5)
        .map { mockPostsGenerator1.mockPostPage.thumbnails[$0] }
      return PostsPage(posts: nextPosts, thumbnails: nextThumbnails)
    }()
    mockPostsGenerator1.index+=5
    return Just(responseData)
      .delay(for: .seconds(0.28), scheduler: DispatchQueue.global(qos: .background))
      .setFailureType(to: Error.self)
      .eraseToAnyPublisher()
  }
  
  func fetchOwnerWrotePosts(isFirstPage: Bool, perPage: Int32) -> AnyPublisher<PostsPage, any Error> {
    if mockPostsGenerator1.index > mockPostsGenerator1.totalPage {
      return Fail(error: PostUseCaseError.noMorePage).eraseToAnyPublisher()
    }
    let responseData = {
      let nextPosts = (mockPostsGenerator1.index..<mockPostsGenerator1.index+5)
        .map { mockPostsGenerator1.mockPostPage.posts[$0] }
      let nextThumbnails = (mockPostsGenerator1.index..<mockPostsGenerator1.index+5)
        .map { mockPostsGenerator1.mockPostPage.thumbnails[$0] }
      return PostsPage(posts: nextPosts, thumbnails: nextThumbnails)
    }()
    mockPostsGenerator1.index+=5
    return Just(responseData)
      .delay(for: .seconds(0.28), scheduler: DispatchQueue.global(qos: .background))
      .setFailureType(to: Error.self)
      .eraseToAnyPublisher()
    
  }
}
