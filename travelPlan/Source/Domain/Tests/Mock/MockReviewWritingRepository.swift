//
//  MockReviewWritingRepository.swift
//  travelPlan
//
//  Created by SeokHyun on 4/20/24.
//

import Foundation
import Combine

final class MockReviewWritingRepository {
  // MARK: - Properties
  private let repository: ReviewWritingRepository
  
  // MARK: - LifeCycle
  init() {
    let mockService = SessionProvider(session: MockSession.default)
    self.repository = DefaultReviewWritingRepository(service: mockService)
  }
}

// MARK: - ReviewWritingRepository
extension MockReviewWritingRepository: ReviewWritingRepository {
  func savePost(with reviewWritingPost: ReviewWritingEntity) -> AnyPublisher<Bool, any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mockResponseData = MockResponseType.post(.reviewWritingPostResponse).mockDataLoader
      return ((HTTPURLResponse(), mockResponseData))
    }
    
    return repository.savePost(with: reviewWritingPost)
      .eraseToAnyPublisher()
  }
  
  func updatePost(entity: ReviewWritingEntity, postId: String) -> AnyPublisher<Post, any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mockResponseData = MockResponseType.post(.reviewWritingPostResponse).mockDataLoader
      return ((HTTPURLResponse(), mockResponseData))
    }
    
    return repository.updatePost(entity: entity, postId: postId)
      .eraseToAnyPublisher()
  }
}
