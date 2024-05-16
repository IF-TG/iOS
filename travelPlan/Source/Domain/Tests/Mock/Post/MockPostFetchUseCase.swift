//
//  MockPostFetchUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 5/16/24.
//

import Combine
import Foundation

final class MockPostFetchUseCase: PostFetchUseCase {
  var mockPostsGenerator = MockPostsGeneratorForPaging()
  
  func fetchFilteredPosts(
    with page: PostFetchRequestValue
  ) -> AnyPublisher<PostsPage, any Error> {
    if mockPostsGenerator.index > mockPostsGenerator.totalPage {
      return Fail(error: PostUseCaseError.noMorePage).eraseToAnyPublisher()
    }
    let responseData = {
      let nextPosts = (mockPostsGenerator.index..<mockPostsGenerator.index+5)
        .map { mockPostsGenerator.mockPostPage.posts[$0] }
      let nextThumbnails = (mockPostsGenerator.index..<mockPostsGenerator.index+5)
        .map { mockPostsGenerator.mockPostPage.thumbnails[$0] }
      return PostsPage(posts: nextPosts, thumbnails: nextThumbnails)
    }()
    mockPostsGenerator.index+=5
    return Just(responseData)
      .delay(for: .seconds(0.28), scheduler: DispatchQueue.global(qos: .background))
      .setFailureType(to: Error.self)
      .eraseToAnyPublisher()
  }
}
