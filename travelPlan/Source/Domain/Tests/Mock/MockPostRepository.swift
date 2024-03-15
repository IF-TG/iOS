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
  
  typealias Endpoint = PostAPIEndpoint
  
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
}
