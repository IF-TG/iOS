//
//  MockPostRepository.swift
//  travelPlan
//
//  Created by 양승현 on 3/8/24.
//

import Combine
import Foundation

final class MockPostRepository: PostRepository {
  let mockService: Sessionable
  var subscription = Set<AnyCancellable>()
  
  let repository: PostRepository
  
  typealias Endpoint = PostAPIEndpoint
  
  init() {
    self.mockService = SessionProvider(session: MockSession.default)
    self.repository = DefaultPostRepository(service: mockService)
  }
  
  func fetchPosts(with page: PostsPage) -> Future<[PostContainer], MainError> {
    let requestDTO = PostsRequestDTO(
      page: 0,
      perPage: 20,
      orderMethod: "임시",
      mainCategory: "임시",
      subCategory: "임시",
      userId: 3)
    let endpoint = Endpoint.fetchPosts(with: requestDTO)
    
    MockUrlProtocol.requestHandler = { _ in
      let mockData = MockResponseType.postContainerResponse.mockDataLoader
      return ((HTTPURLResponse(), mockData))
    }
    
    return .init { [unowned self] promise in
      mockService.request(endpoint: endpoint)
        .sink { completion in
          if case .failure(let error) = completion {
            promise(.failure(MainError.networkError(error)))
          }
        } receiveValue: { responseDTO in
          promise(.success(responseDTO.result.map { $0.toDomain() }))
        }.store(in: &subscription)
    }
  }
  
  func fetchComments(page: Int32, perPage: Int32, postId: Int64) -> Future<PostCommentContainerEntity, any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mockData = MockResponseType.postCommentContainerResponse.mockDataLoader
      return ((HTTPURLResponse(), mockData))
    }
    return Future { [unowned self] promise in
      repository.fetchComments(page: page, perPage: perPage, postId: postId).sink { completion in
        if case .failure(let error) = completion {
          promise(.failure(error))
        }
      } receiveValue: { containerEntity in
        promise(.success(containerEntity))
      }.store(in: &subscription)
    }
  }
}
