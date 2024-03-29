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
  
  func fetchPosts(page: Int32, perPage: Int32, category: PostCategory) -> Future<PostsPage, any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mockData = MockResponseType.postContainerResponse.mockDataLoader
      return ((HTTPURLResponse(), mockData))
    }
    return Future { promise in
      DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5) { [weak self] in
        let subscription = self?.postRepository
          .fetchPosts(page: page, perPage: perPage, category: category)
          .sink(receiveCompletion: { completion in
            if case .failure(let error) = completion {
              promise(.failure(error))
            }
          }, receiveValue: { postsPage in
            promise(.success(postsPage))
          })
        self?.subscriptions.insert(subscription)
      }
    }
  }
  
  func fetchComments(page: Int32, perPage: Int32, postId: Int64) -> Future<PostCommentContainerEntity, any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mockData = MockResponseType.postCommentContainerResponse.mockDataLoader
      return ((HTTPURLResponse(), mockData))
    }
    return Future { promise in
      DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5) { [weak self] in
        let subscription = self?.postRepository
          .fetchComments(page: page, perPage: perPage, postId: postId)
          .sink(receiveCompletion: { completion in
            if case .failure(let error) = completion {
              promise(.failure(error))
            }
          }, receiveValue: { postCommentContainerEntity in
            promise(.success(postCommentContainerEntity))
          })
        self?.subscriptions.insert(subscription)
      }
    }
  }
}
