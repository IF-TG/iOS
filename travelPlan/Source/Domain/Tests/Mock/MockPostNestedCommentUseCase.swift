//
//  MockPostNestedCommentUseCase.swift
//  travelPlan
//
//  Created by 양승현 on 3/27/24.
//

import Foundation
import Combine

final class MockPostNestedCommentRepository: PostNestedCommentRepository {
  // MARK: - Properties
  private let mockService: Sessionable
  private var subscriptions = Set<AnyCancellable?>()
  private let wrappedRepository: PostNestedCommentRepository
  
  init() {
    self.mockService = SessionProvider(session: MockSession.default)
    self.wrappedRepository = DefaultPostNestedCommentRepository(service: mockService)
  }
  
  // MARK: - Helpers
  func sendNestedComment(
    commentId: Int64,
    comment: String
  ) -> Future<PostNestedCommentEntity, any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mockData = MockResponseType.postNestedComment(.whenCommentSend).mockDataLoader
      return ((HTTPURLResponse(), mockData))
    }
    return Future { promise in
      DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5) { [weak self] in
        let subscription = self?.wrappedRepository
          .sendNestedComment(commentId: commentId, comment: comment)
          .sink { completion in
            if case .failure(let error) = completion {
              promise(.failure(error))
            }
          } receiveValue: { entity in
            promise(.success(entity))
          }
        self?.subscriptions.insert(subscription)
      }
    }
  }
  
}
