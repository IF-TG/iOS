//
//  MockPostNestedCommentRepository.swift
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
  
  func updateNestedComment(nestedCommentId: Int64, comment: String) -> Future<Bool, any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mockData = MockResponseType.postNestedComment(.whenCommentUpdate).mockDataLoader
      return ((HTTPURLResponse(), mockData))
    }
    return Future { promise in
      DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5) { [weak self] in
        let subscription = self?.wrappedRepository
          .updateNestedComment(nestedCommentId: nestedCommentId, comment: comment)
          .sink { completion in
            if case .failure(let error) = completion {
              promise(.failure(error))
            }
          } receiveValue: { result in
            promise(.success(result))
          }
        self?.subscriptions.insert(subscription)
      }
    }
  }
  
  func deleteNestedComment(nestedCommentId: Int64) -> Future<Bool, any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mockData = MockResponseType.postNestedComment(.whenCommentDelete).mockDataLoader
      return ((HTTPURLResponse(), mockData))
    }

    return Future { promise in
      DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5) { [weak self] in
        let subscription = self?.wrappedRepository
          .deleteNestedComment(nestedCommentId: nestedCommentId)
          .sink { completion in
            if case .failure(let error) = completion {
              promise(.failure(error))
            }
          } receiveValue: { result in
            promise(.success(result))
          }
        self?.subscriptions.insert(subscription)
      }
    }
  }
}
