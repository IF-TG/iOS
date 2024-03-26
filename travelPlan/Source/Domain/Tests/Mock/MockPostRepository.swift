//
//  MockPostRepository.swift
//  travelPlan
//
//  Created by 양승현 on 3/8/24.
//

import Combine
import Foundation

final class MockPostRepository: PostRepository {
  typealias Endpoint = PostAPIEndpoint
  
  let mockService: Sessionable
  var subscriptions = Set<AnyCancellable?>()
  let postRepository: PostRepository
  
  
  init() {
    self.mockService = SessionProvider(session: MockSession.default)
    self.postRepository = DefaultPostRepository(service: mockService)
  }
  
  func fetchPosts(
    page: Int32,
    perPage: Int32,
    category: PostCategory
  ) -> Future<[PostContainer], any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mockData = MockResponseType.postContainerResponse.mockDataLoader
      return ((HTTPURLResponse(), mockData))
    }
    return postRepository.fetchPosts(page: page, perPage: perPage, category: category)
  }
  
  func fetchComments(page: Int32, perPage: Int32, postId: Int64) -> Future<PostCommentContainerEntity, any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mockData = MockResponseType.postCommentContainerResponse.mockDataLoader
      return ((HTTPURLResponse(), mockData))
    }
    return Future { [weak self] promise in
      let subscription = self?.postRepository.fetchComments(page: page, perPage: perPage, postId: postId).sink { completion in
        if case .failure(let error) = completion {
          promise(.failure(error))
        }
      } receiveValue: { containerEntity in
        promise(.success(containerEntity))
      }
      self?.subscriptions.insert(subscription)
    }
  }
}
