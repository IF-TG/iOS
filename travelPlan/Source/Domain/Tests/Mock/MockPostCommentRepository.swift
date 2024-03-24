//
//  MockPostCommentRepository.swift
//  travelPlan
//
//  Created by 양승현 on 3/23/24.
//

import Foundation
import Combine

/// 기본 동작 레포지토리에  mockSession을 통해 mock 데이터를 주입한 Wrapped객체입니다.
final class MockPostCommentRepository: PostCommentRepository {
  let mockService: Sessionable
  var subscriptions = Set<AnyCancellable?>()
  
  let repository: PostCommentRepository
  
  init() {
    self.mockService = SessionProvider(session: MockSession.default)
    self.repository = DefaultPostCommentRepository(service: mockService)
  }
}

extension MockPostCommentRepository {
  func sendComment(postId: Int64, comment: String) -> Future<PostCommentEntity, any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mockData = MockResponseType.postComment(.whenCommentSend).mockDataLoader
      return ((HTTPURLResponse(), mockData))
    }
    return Future { promise in
      DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5) { [weak self] in
        let subscription = self?.repository.sendComment(postId: postId, comment: comment)
          .sink { completion in
            if case .failure(let error) = completion {
              promise(.failure(error))
            }
          } receiveValue: { postCommentEntity in
            promise(.success(postCommentEntity))
          }
        self?.subscriptions.insert(subscription)
      }
    }
  }
  
  func updateComment(commentId: Int64, comment: String) -> Future<UpdatedPostCommentEntity, any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mock = MockResponseType.postComment(.whenCommentUpdate).mockDataLoader
      return ((HTTPURLResponse(), mock))
    }
    return Future { promise in
      DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5) { [weak self] in
        let subscription = self?.repository.updateComment(commentId: commentId, comment: comment)
          .sink { completion in
            if case .failure(let error) = completion {
              promise(.failure(error))
            }
          } receiveValue: { updatedPostCommentEntity in
            promise(.success(updatedPostCommentEntity))
          }
        self?.subscriptions.insert(subscription)
      }
    }
  }
  
  func deleteComment(commentId: Int64) -> Future<Bool, any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mock = MockResponseType.postComment(.whenCommentDelete).mockDataLoader
      return ((HTTPURLResponse(), mock))
    }
    return Future { promise in
      DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5) { [weak self] in
        let subscription = self?.repository.deleteComment(commentId: commentId)
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
  
  func fetchComments(page: Int32, perPage: Int32, postId: Int64) -> Future<[PostCommentEntity], any Error> {
    MockUrlProtocol.requestHandler = { _ in
      let mock = MockResponseType.postComment(.whenCommentsFetch).mockDataLoader
      return ((HTTPURLResponse(), mock))
    }
    return Future { promise in
      DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5) { [weak self] in
        let subscription = self?.repository
          .fetchComments(page: page, perPage: perPage, postId: postId)
          .sink { completion in
            if case .failure(let error) = completion {
              promise(.failure(error))
            }
          } receiveValue: { postCommentEntities in
            promise(.success(postCommentEntities))
          }
        self?.subscriptions.insert(subscription)
      }
    }
  }
  
  /// 임시 구현
  func toggleCommentHeart(commentId: Int64) -> Future<ToggledPostCommentHeartEntity, any Error> {
    return Future { promise in
      promise(.failure(ReferenceError.invalidReference))
    }
  }
}
