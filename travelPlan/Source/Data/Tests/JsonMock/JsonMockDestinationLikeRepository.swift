//
//  JsonMockDestinationLikeRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 7/24/24.
//

import Foundation
import Combine

final class JsonMockDestinationLikeRepository {
  // MARK: - Properties
  private let repository: DestinationLikeRepository
  
  // MARK: - LifeCycle
  init(backgroundQueue: DispatchQueue = .global(qos: .userInitiated)) {
    self.repository = DefaultDestinationLikeRepository(
      service: SessionProvider(session: MockSession.default),
      backgroundQueue: backgroundQueue
    )
  }
}

// MARK: - DestinationLikeRepository
extension JsonMockDestinationLikeRepository: DestinationLikeRepository {
  func toggleDestinationLike(destinationId: Int) -> AnyPublisher<DestinationLike, any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mockData = MockResponseType
        .destinationLike(.toggleLikeDestination)
        .mockDataLoader
      return (HTTPURLResponse(), mockData)
    }
    
    return repository.toggleDestinationLike(destinationId: destinationId)
  }
}
