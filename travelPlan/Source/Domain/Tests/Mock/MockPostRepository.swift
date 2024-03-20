//
//  MockPostRepository.swift
//  travelPlan
//
//  Created by 양승현 on 3/8/24.
//

import Combine
import Foundation

final class MockPostRepository: PostRepository {
  let mockService = SessionProvider(session: MockSession.default)
  var subscription = Set<AnyCancellable>()
  
  private lazy var postRepository = DefaultPostRepository(service: mockService)
  
  typealias Endpoint = PostAPIEndpoint
  
  func fetchPosts(page: Int32, perPage: Int32, category: PostsPage.Category) -> Future<[PostContainer], any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mockData = MockResponseType.postContainerResponse.mockDataLoader
      return ((HTTPURLResponse(), mockData))
    }
    return postRepository.fetchPosts(page: page, perPage: perPage, category: category)
  }
}
